module GameOverseer
  class TCP_Server # Underscore required to prevent initialize loop
    include Celluloid::IO
    finalizer :finalize

    def initialize(host, port)
      GameOverseer::Console.log("Server> Started on: #{host}:#{port}.")
      GameOverseer::Services.enable

      @message_manager = ObjectSpace.each_object(GameOverseer::MessageManager).first

      @server = TCPServer.new(host = '0.0.0.0', port)
      async.run
    end

    def run
      loop do
        async.handle_connection(@server.accept)
        async.handle_messages
      end
    end

    def finalize
      @server.close if @server
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

  class TCPServerRunner
    attr_reader :supervisor
    def start(host, port)
      @supervisor = GameOverseer::TCP_Server.supervise(host, port)
    end

    def supervisor
      @supervisor
    end
  end
end
