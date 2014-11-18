module GameOverseer
  module Services
    LIST = []
    ACTIVE=[]

    def self.register(klass)
      LIST << klass
    end

    def self.enable
      LIST.each do |service|
        _service = service.new
        _service.enable
        GameOverseer::Console.log "Services> #{_service.class} #{_service.version}"
        ACTIVE << _service
      end
    end
  end
end
