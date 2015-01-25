require "set"
require "net/ssh"
require "securerandom"

require "gosu"
require "celluloid"
require "renet"
require "multi_json"

require_relative "version"

require_relative "console/console"

require_relative "channels/channel_manager"

require_relative "messages/message_manager"

require_relative "services/service"
require_relative "services/services"
require_relative "services/internal/services"

require_relative "input_handler/input_handler"

require_relative "server/renet_server"
require_relative "server/handshake"

# TEMP
Thread.abort_on_exception = true

# TODO: Move to own file
module GameOverseer
  def self.activate(host,port)
    GameOverseer::ChannelManager.new
    GameOverseer::MessageManager.new
    @server  = Thread.new {GameOverseer::ENetServerRunner.new.start(host, port)}
    console = GameOverseer::Console.new.show

    Signal.trap("INT") do
      GameOverseer::Console.instance.close
      @server.supervisor.terminate
      puts "Server Shutdown"
    end
  end

  def self.deactivate
    puts "ALERT \"CONSOLE CLOSED. LOST CONTROL OF SERVER.\""
    @server.supervisor.terminate
  end
end

# Activate self, remove this before a release.
GameOverseer.activate("localhost", 56789)
