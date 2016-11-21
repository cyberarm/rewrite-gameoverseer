module GameOverseer
  class JsonPacketHandler < PacketHandler

    def setup
      begin
        require "multi_json"
      rescue LoadError
        abort "MultiJson is not installed."
      end
    end

    def pre_processor(packet, sending)
      data = nil
      if sending
        data = MultiJson.dump(packet)
      else
        data = MultiJson.load(packet)
      end

      return data
    end

    def receive(client_id, packet)
      _packet = pre_processor(packet, false)
    end

    def transmit(client_id, data)
      _packet = pre_processor(data, true)
    end
  end
end
