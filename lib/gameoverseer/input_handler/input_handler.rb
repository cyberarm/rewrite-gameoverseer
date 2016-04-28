module GameOverseer
  class InputHandler

    # @param client_id [Integer]
    # @param data [Hash]
    def self.process_data(client_id, data)
      @data = data
      @client_id = client_id
      forward_to_channel_manager if data_valid?
    end

    # Checks if hash contains 'channel' and 'mode'
    # @return [Boolean]
    def self.data_valid?
      if @data["channel"]
        if @data["mode"]
          true
        end
      end
    end

    # Sends data and client_id to {ChannelManager}
    def self.forward_to_channel_manager
      count = 0
      begin
        channel_manager = GameOverseer::ChannelManager.instance
        channel_manager.send_to_service(@client_id, @data)
      rescue NoMethodError => e
        GameOverseer::Console.log("InputHandler> #{e.to_s}")
        raise if count >=2
        count+=1
        retry unless count >= 2
      end
    end
  end
end
