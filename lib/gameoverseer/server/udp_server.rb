module GameOverseer
  class UDP_Server
    include Celluloid::IO
    finalizer :finalize

    def initialize(host, port)
      GameOverseer::Console.log("Server> Started on: #{host}:#{port}.")
      GameOverseer::Services.enable
      @message_manager = GameOverseer::MessageManager.new

      @server = UDPSocket.new
      @server.bind(host, port)
      run
    end

    def run
      loop do
        begin
          async.handle_connection(@server.recvfrom(4096))
          async.handle_messages
        rescue Errno::ECONNRESET => e
          retry # retry forever!
                # what could go wrong?
        end
      end
    end

    def finalize
      @server.close if @server
    end

    def handle_connection(socket)
      receive_data(socket)
    end

    def receive_data(socket)
      @data = socket[0]
      @socket=socket
      begin
        @data = MultiJson.load(@data)
        process_data(@data, @socket)
      rescue MultiJson::ParseError => e
        send_data("{\"channel\": \"__UNDEFINED__\", \"mode\": \"__UNDEFINED__\", \"data\": {\"code\": 400, \"message\": \"Invalid JSON received.\"}}")
        GameOverseer::Console.log("Server> Parse error: '#{e.to_s}'. Bad data: '#{@data}' received from client.")
      end
    end

    def send_data(string, method=0, host=@socket[1][2], port=@socket[1][1])
      @server.send(string, method, host, port)
    end

    def process_data(data, socket)
      GameOverseer::InputHandler.process_data(data, socket)
    end

    def handle_messages
      @message_manager.messages.each do |message|
        p message
        send_data(message[:message], 0, message[:socket][1][2], message[:socket][1][1])
      end

      @message_manager.low_messages.each do |message|
        send_data(message[:message], 0, message[:socket][1][2], message[:socket][1][1])
      end
    end
  end

  class UDPServerRunner
    def start(host, port)
      @supervisor = GameOverseer::UDPServer.supervise(host, port)
    end

    def supervisor
      @supervisor
    end
  end
end
