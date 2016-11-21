module GameOverseer

  # Handles sending messages to clients on behalf of services
  class MessageManager
    MESSAGES = []
    BROADCASTS = []

    def initialize
      MessageManager.instance = self
    end

    # Send a message to a specific client
    # @param client_id [Integer] ID of client
    # @param string [String] message to send
    # @param reliable [Boolean] whether or not packet delivery is reliable
    # @param channel [Integer] What channel to send on
    def message(client_id, string, reliable = false, channel = ChannelManager::CHAT)
      GameOverseer::ENetServer.instance.transmit(client_id, string, reliable, channel)
    end


    # Send a message to all connected clients
    # @param string [String] message to send
    # @param reliable [Boolean] whether or not packet delivery is reliable
    # @param channel [Integer] What channel to send on
    def broadcast(string, reliable = false, channel = ChannelManager::CHAT)
      GameOverseer::ENetServer.instance.broadcast(string, reliable, channel)
    end

    # @return [MessageManager]
    def self.instance
      @instance
    end

    # @param _instance [MessageManager]
    def self.instance=_instance
      @instance = _instance
    end
  end
end
