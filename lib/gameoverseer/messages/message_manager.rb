module GameOverseer
  class MessageManager
    MESSAGES = []
    BROADCASTS = []

    def initialize
      MessageManager.instance = self
    end

    def message(client_id, string, reliable = false, channel = ChannelManager::CHAT)
      GameOverseer::ENetServer.instance.send(client_id, string, reliable, channel)
      GameOverseer::Console.log("MessageManager> #{string}-#{client_id}")
    end

    def broadcast(string, reliable = false, channel = ChannelManager::CHAT)
      GameOverseer::ENetServer.instance.broadcast(string, reliable, channel)
      GameOverseer::Console.log("MessageManager> #{string}-#{channel}")
    end

    def messages
      MESSAGES
    end

    def broadcasts
      BROADCASTS
    end

    def self.instance
      @instance
    end

    def self.instance=_instance
      @instance = _instance
    end
  end
end
