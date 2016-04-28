module GameOverseer
  class PacketHandler

    def initialize
      PacketHandler.instance = self
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

    def self.instance
      @instance
    end

    def self.instance=(_instance)
      @instance = _instance
    end
  end
end
