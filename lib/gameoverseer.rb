require "set"

require "gosu"
require "celluloid"
require "renet"
require "multi_json"

require_relative "gameoverseer/version"

require_relative "gameoverseer/console/console"

require_relative "gameoverseer/channels/channel_manager"

require_relative "gameoverseer/messages/message_manager"

require_relative "gameoverseer/clients/client_manager"

require_relative "gameoverseer/services/service"
require_relative "gameoverseer/services/services"
require_relative "gameoverseer/services/internal/services"

require_relative "gameoverseer/input_handler/input_handler"

require_relative "gameoverseer/server/renet_server"
require_relative "gameoverseer/server/handshake"

# TEMP
Thread.abort_on_exception = true

# TODO: Move to own file
module GameOverseer
  def self.activate(host, port)
    GameOverseer::ChannelManager.new
    GameOverseer::MessageManager.new
    GameOverseer::ClientManager.new

    # @console = GameOverseer::Console.new
    @server  = GameOverseer::ENetServerRunner.new

    # Thread.new {@console.show}
    Thread.new {@server.start(host, port)}
    sleep

    at_exit do
      # GameOverseer::Console.instance.close
      @server.supervisor.terminate if defined?(@server.supervisor.terminate)
      puts "Server Shutdown"
    end
  end

  def self.deactivate
    puts "ALERT \"CONSOLE CLOSED. LOST CONTROL OF SERVER.\""
    @server.supervisor.terminate
  end
end

# Activate self, remove this before a release.
# GameOverseer.activate("localhost", 56789)
