module GameOverseer
  class MessageManager
    MESSAGES = []
    LOW_MESSAGES = []

    def initialize
      MessageManager.instance = self
    end

    def message_low(string, socket)
      LOW_MESSAGES << {message: string, socket: socket}
      GameOverseer::Console.log("MessageManager> #{string}-#{socket}")
    end

    def message(string, socket)
      MESSAGES << {message: string, socket: socket}
      GameOverseer::Console.log("MessageManager> #{string}-#{socket}")
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
