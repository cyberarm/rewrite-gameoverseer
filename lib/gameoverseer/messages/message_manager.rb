module GameOverseer
  class MessageManager
    MESSAGES = []
    BROADCASTS = []

    def initialize
      MessageManager.instance = self
    end

    def message(string, client_id, reliable = false, channel = ChannelManager::CHAT)
      MESSAGES << {message: string, client_id: client_id, reliable: reliable, channel: channel}
      GameOverseer::Console.log("MessageManager> #{string}-#{client_id}")
    end

    def broadcast(string, client_id, reliable = false, channel = ChannelManager::CHAT)
      BROADCASTS << {message: string, client_id: client_id, reliable: reliable, channel: channel}
      GameOverseer::Console.log("MessageManager> #{string}-#{client_id}")
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
