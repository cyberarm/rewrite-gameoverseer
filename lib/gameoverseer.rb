require "set"
require "openssl"

require "concurrent"
require "renet"
require "multi_json"

require_relative "gameoverseer/version"

begin
  require_relative "gameoverseer/console/console"
rescue => e
  require_relative "gameoverseer/console/namespace_creator"
  require_relative "gameoverseer/console/console"
end

require_relative "gameoverseer/channels/channel_manager"

require_relative "gameoverseer/messages/message_manager"

require_relative "gameoverseer/clients/client_manager"

require_relative "gameoverseer/services/service"
require_relative "gameoverseer/services/services"

require_relative "gameoverseer/input_handler/input_handler"

require_relative "gameoverseer/packet_handler/packet_handler"
require_relative "gameoverseer/encryption_handler/encryption_handler"

require_relative "gameoverseer/server/renet_server"


Thread.abort_on_exception = true
# General purpose game server that uses services (plugins) for logic.
module GameOverseer

  # Start server
  def self.activate(host, port, use_inbuilt_console = false, packet_handler = PacketHandler, encryption_handler = nil)
    begin
      GameOverseer::Console.log "Using inbuilt console"
      require "gosu" if use_inbuilt_console
    rescue LoadError
      fatal "Install gosu 0.10.8 or later to use inbuilt console."
    end

    GameOverseer::ChannelManager.new
    GameOverseer::MessageManager.new
    GameOverseer::ClientManager.new

    @console = GameOverseer::Console.new if use_inbuilt_console
    @server  = GameOverseer::ENetServerRunner.new

    Thread.new {@server.start(host, port, packet_handler, encryption_handler)}
    @console.show if use_inbuilt_console
    sleep

    at_exit do
      GameOverseer::Console.instance.close if use_inbuilt_console
      @server.supervisor.terminate if defined?(@server.supervisor.terminate)
      GameOverseer::Console.log "Server Shutdown"
    end
  end

  # Stop server
  def self.deactivate
    puts "ALERT \"CONSOLE CLOSED. LOST CONTROL OF SERVER.\""
    @server.supervisor.terminate
  end
end
