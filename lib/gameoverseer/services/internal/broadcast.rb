module GameOverseer
  class InternalService
    class Broadcast < GameOverseer::Service
      def setup
        channel_manager.register_channel('broadcast', self)
      end

      def version
        "0.1.0"
      end
    end
  end
end
