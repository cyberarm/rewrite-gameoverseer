module GameOverseer
  class InternalService
    class Handshake < GameOverseer::Service
      def setup
        p channel_manager
        channel_manager.register_channel('handshake', self)
      end

      def process(data)
        p data
        data_to_method(data)
      end

      def extend_hand(data)
        puts "here?"
        message = MultiJson.dump({channel: 'handshake', mode: 'public_key', data: {public_key: GameOverseer::HandShake.public_key}})
        message_manager.message("#{message}", socket)
        log("#{self.class}> #{message}.", Gosu::Color::RED)
      end



      def version
        "0.1.0"
      end
    end
  end
end
