require "set"

require "gosu"
require "concurrent"
require "renet"
require "multi_json"

require_relative "gameoverseer/version"

require_relative "gameoverseer/console/console"

require_relative "gameoverseer/channels/channel_manager"

require_relative "gameoverseer/messages/message_manager"

require_relative "gameoverseer/clients/client_manager"

require_relative "gameoverseer/services/service"
require_relative "gameoverseer/services/services"

require_relative "gameoverseer/input_handler/input_handler"

require_relative "gameoverseer/server/renet_server"
require_relative "gameoverseer/server/encryption"

# General purpose game server that uses services (plugins) for logic.
module GameOverseer

  # Start server
  def self.activate(host, port)
    GameOverseer::ChannelManager.new
    GameOverseer::MessageManager.new
    GameOverseer::ClientManager.new

    @console = GameOverseer::Console.new
    @server  = GameOverseer::ENetServerRunner.new

    Thread.new {@server.start(host, port)}
    @console.show
    sleep

    at_exit do
      GameOverseer::Console.instance.close
      @server.supervisor.terminate if defined?(@server.supervisor.terminate)
      puts "Server Shutdown"
    end
  end

  # Stop server
  def self.deactivate
    puts "ALERT \"CONSOLE CLOSED. LOST CONTROL OF SERVER.\""
    @server.supervisor.terminate
  end
end
