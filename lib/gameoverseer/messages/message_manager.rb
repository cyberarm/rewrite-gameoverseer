module GameOverseer
  class MessageManager
    MESSAGES = []
    LOW_MESSAGES = []

    def initialize
      MessageManager.instance = self
    end

    def message_low(string, client_id)
      LOW_MESSAGES << {message: string, client_id: client_id}
      GameOverseer::Console.log("MessageManager> #{string}-#{client_id}")
    end

    def message(string, client_id)
      MESSAGES << {message: string, client_id: client_id}
      GameOverseer::Console.log("MessageManager> #{string}-#{client_id}")
    end

    def messages
      MESSAGES
    end

    def low_messages
      LOW_MESSAGES
    end

    def self.instance
      @instance
    end

    def self.instance=_instance
      @instance = _instance
    end
  end
end
