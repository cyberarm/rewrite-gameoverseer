module GameOverseer
  class ChannelManager
    def initialize
      @channels = {}
      # 'chat' => GameOverseer::InternalService::Chat,
      # 'handshake' => GameOverseer::InternalService::Handshake,
      # 'heartbeat' => GameOverseer::InternalService::HeartBeat,
      # 'broadcast' => GameOverseer::InternalService::Broadcast,
      # 'environment' => GameOverseer::InternalService::Environment
    end

    def register_channel(channel, service)
      _channel = channel.downcase
      unless @channels[_channel]
        @channels[_channel] = service
        GameOverseer::Console.log("ChannelManager> mapped '#{_channel}' to '#{service.class}'.")
      end
    end

    def send_to_service(data, socket)
      GameOverseer::Console.log("ChannelManager> sent '#{data}' to '#{@channels[data['channel']].class}'.")
      @channels[data['channel']].socket = socket
      @channels[data['channel']].process(data)
    end
  end
end
