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

    def self.client_connected(client_id, ip_address)
      ACTIVE.each do |service|
        service.client_connected(client_id, ip_address) if defined?(service.client_connected)
      end
    end

    def self.client_disconnected(client_id)
      ACTIVE.each do |service|
        service.client_disconnected(client_id) if defined?(service.client_disconnected)
      end
    end
  end
end
