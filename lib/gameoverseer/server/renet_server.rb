module GameOverseer
  class ENetServer
    include Celluloid

    def initialize(host, port)
      GameOverseer::Console.log("Server> Started on: #{host}:#{port}.")
      GameOverseer::Services.enable
      @message_manager = GameOverseer::MessageManager.instance
      @channel_manager = GameOverseer::ChannelManager.instance
      @client_manager = GameOverseer::ClientManager.instance

      @server = ENet::Server.new(port, 4, 4, 0, 0) # Port, max clients, channels, download bandwidth, upload bandwith

      @server.on_connection(method(:on_connect))
      @server.on_packet_receive(method(:on_packet))
      @server.on_disconnection(method(:on_disconnect))
      async.run
    end

    def run
      loop do
        @server.update(1000)
        handle_messages
      end
    end

    def on_packet(client_id, data, channel)
      p "Packet: #{client_id}-#{data}-#{channel}"
      handle_connection(client_id, data, channel)
    end

    def on_connect(client_id, ip_address)
      p "Connect: #{client_id}-#{ip_address}"
      @client_manager.add(client_id, ip_address)
      send(client_id, "HANDSHAKE", true, ChannelManager::HANDSHAKE)
    end

    def on_disconnect(client_id)
      p "Disconnect: #{client_id}"
      @client_manager.remove(client_id)
    end

    # send (private packet)
    def send(client_id, message, reliable = false, channel = ChannelManager::CHAT)
      p client_id
      @server.send_packet(client_id, message, reliable, channel)
    end

    # boardcast (global packet)
    def broadcast(message, reliable = false, channel = ChannelManager::CHAT)
      @server.broadcast_packet(message, reliable, channel)
    end

    def process_data(data, socket)
      GameOverseer::InputHandler.process_data(data, socket)
    end

    def handle_connection(client_id, data, channel)
      begin
        data = MultiJson.load(data)
        process_data(data, client_id)
      rescue MultiJson::ParseError => e
        send(client_id, " \"channel\": \"__UNDEFINED__\", \"mode\": \"__UNDEFINED__\", \"data\": {\"code\": 400, \"message\": \"Invalid JSON received.\"}}", true, ChannelManager::FAULT)
        GameOverseer::Console.log("Server> Parse error: '#{e.to_s}'. Bad data: '#{data}' received from client.")
      end
    end

    def handle_messages
      @message_manager.messages.each do |message|
        p message[:message]
        send(message[:client_id], message[:message])
      end

      @message_manager.low_messages.each do |message|
        p message[:message]
        send(message[:client_id], message[:message])
      end

      # TODO: implement broadcast messages in MessageManager
      # @message_manager.broadcasts.each do |message
      #   broadcast(message[:message], message[:client_id])
      # end
    end
  end

  class ENetServerRunner
    attr_reader :supervisor
    def start(host, port)
      @supervisor = GameOverseer::ENetServer.new(host, port)
    end
  end
end
