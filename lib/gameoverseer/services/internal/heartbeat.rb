module GameOverseer
  class InternalService
    class HeartBeat < GameOverseer::Service
      def version
        "0.1.0"
      end
    end
  end
end
