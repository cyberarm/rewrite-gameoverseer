module GameOverseer
  class PacketHandler

    def initialize
      PacketHandler.instance = self
      setup
    end

    def setup
    end

    def pre_processor(packet, sending)
    end

    def receive(client_id, packet)
    end

    def transmit(client_id, data)
    end

    def self.instance
      @instance
    end

    def self.instance=(_instance)
      @instance = _instance
    end
  end
end
