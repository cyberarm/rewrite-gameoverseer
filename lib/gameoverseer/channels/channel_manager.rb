module GameOverseer
  class ChannelManager
    CHAT = 0
    WORLD= 1
    HANDSHAKE = 2
    FAULT=3
    def initialize
      @channels = {}
      ChannelManager.instance = self # quick and lazy way to remove objectspace
      # 'chat' => GameOverseer::InternalService::Chat,
      # 'handshake' => GameOverseer::InternalService::Handshake,
      # 'broadcast' => GameOverseer::InternalService::Broadcast,
      # 'environment' => GameOverseer::InternalService::Environment
    end

    def register_channel(channel, service)
      _channel = channel.downcase
      unless @channels[_channel]
        @channels[_channel] = service
        GameOverseer::Console.log("ChannelManager> mapped '#{_channel}' to '#{service.class}'.")
      else
        raise "Could not map channel '#{_channel}' because '#{@channels[data[_channel]].class}' is already using it."
      end
    end

    def send_to_service(data, client_id)
      GameOverseer::Console.log("ChannelManager> sent '#{data}' to '#{@channels[data['channel']].class}'.")
      @channels[data['channel']].client_id = client_id
      @channels[data['channel']].process(data)
    end

    def self.instance
      @instance
    end

    def self.instance=_instance
      @instance = _instance
    end
  end
end
