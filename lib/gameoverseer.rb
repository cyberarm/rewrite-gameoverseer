require "set"

require "gosu"
require "celluloid"
require "renet"
require "multi_json"

require_relative "gamoverseer/version"

require_relative "gamoverseer/console/console"

require_relative "gamoverseer/channels/channel_manager"

require_relative "gamoverseer/messages/message_manager"

require_relative "gamoverseer/clients/client_manager"

require_relative "gamoverseer/services/service"
require_relative "gamoverseer/services/services"
require_relative "gamoverseer/services/internal/services"

require_relative "gamoverseer/input_handler/input_handler"

require_relative "gamoverseer/server/renet_server"
require_relative "gamoverseer/server/handshake"

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
