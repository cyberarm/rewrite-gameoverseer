module GameOverseer
  class MessagePackPacketHandler < PacketHandler

    def setup
      begin
        require "msgpack"
      rescue => LoadError
        abort "msgpack is not installed."
      end
    end

    def pre_processor(packet, sending)
      data = nil
      if sending
        data = packet.to_msgpack
      else
        data = MessagePack.unpack(packet)
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
