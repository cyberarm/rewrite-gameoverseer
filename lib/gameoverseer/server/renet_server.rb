module GameOverseer
  class ENetServer
    # include Celluloid

    def initialize(host, port)
      GameOverseer::Console.log("Server> Started on: #{host}:#{port}.")
      GameOverseer::Services.enable
      @message_manager = GameOverseer::MessageManager.instance
      @channel_manager = GameOverseer::ChannelManager.instance

      @server = ENet::Server.new(port, 4, 4, 0, 0) # Port, max clients, channels, download bandwidth, upload bandwith

      @server.on_connection(method(:on_connect))
      @server.on_packet_receive(method(:on_packet))
      @server.on_disconnection(method(:on_disconnect))
      run
    end

    def run
      loop do
        @server.update(1000)
        handle_messages
      end
    end

    def on_packet(id, data, channel)
      p "Packet: #{id}-#{data}-#{channel}"
      @server.send_packet(id, "HELLO", true, 0)
    end

    def on_connect(data, channel)
      p "Connect: #{data}-#{channel}"
    end

    def on_disconnect(data, channel)
      p "Disconnect: #{data}-#{channel}"
    end

    def handle_connection(socket)
      @data = socket.gets.chomp
      @socket=socket
      begin
        @data = MultiJson.load(@data)
        process_data(@data, @socket)
      rescue MultiJson::ParseError => e
        send_data("{\"channel\": \"__UNDEFINED__\", \"mode\": \"__UNDEFINED__\", \"data\": {\"code\": 400, \"message\": \"Invalid JSON received.\"}}")
        GameOverseer::Console.log("Server> Parse error: '#{e.to_s}'. Bad data: '#{@data}' received from client.")
      end
    end

    def send_data(string, socket)
      @socket.puts(string)
    end

    def process_data(data, socket)
      GameOverseer::InputHandler.process_data(data, socket)
    end

    def handle_messages
      @message_manager.messages.each do |message|
        send_data(message[:message], message[:socket])
      end

      @message_manager.low_messages.each do |message|
        send_data(message[:message], message[:socket])
      end
    end
  end

  class ENetServerRunner
    attr_reader :supervisor
    def start(host, port)
      @supervisor = GameOverseer::ENetServer.new(host, port)
    end

    def supervisor
      @supervisor
    end
  end
end
