module GameOverseer

  # Handles routing packets to the services that subscribe to channels
  class ChannelManager
    CHAT = 0
    WORLD= 1
    HANDSHAKE = 2
    FAULT=3

    def initialize
      @channels = {}
      ChannelManager.instance = self
    end

    # Enables a service to subscribe to a channel
    # @param channel [String]
    # @param service [Service]
    def register_channel(channel, service)
      _channel = channel.downcase
      unless @channels[_channel]
        @channels[_channel] = service
        GameOverseer::Console.log("ChannelManager> mapped '#{_channel}' to '#{service.class}'.")
      else
        raise "Could not map channel '#{_channel}' because '#{@channels[data[_channel]].class}' is already using it."
      end
    end

    # Routes packet to {Service}
    # @param client_id [Integer] ID of client that sent the packet
    # @param data [Hash] data from packet
    def send_to_service(client_id, data)
      GameOverseer::Console.log("ChannelManager> sent '#{data}' to '#{@channels[data['channel']].class}'.")
      @channels[data['channel']].client_id = client_id
      @channels[data['channel']].process(data)
    end

    # Returns instance of active {ChannelManager}
    # @return [ChannelManager]
    def self.instance
      @instance
    end

    # Sets instance of {ChannelManager} that is used through out the system
    # @param _instance [ChannelManager]
    def self.instance=_instance
      @instance = _instance
    end
  end
end
