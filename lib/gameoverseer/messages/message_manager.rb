module GameOverseer
  class MessageManager
    MESSAGES = []
    LOW_MESSAGES = []

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
  end
end
