module GameOverseer
  module Services
    LIST = []
    ACTIVE=[]

    # Adds klass to list
    # @param klass [Service] Service class to add to services list
    def self.register(klass)
      LIST << klass
    end

    # instantiates the Services in 'LIST' and adds them to the 'ACTIVE' list
    def self.enable
      LIST.each do |service|
        _service = service.new
        GameOverseer::Console.log "Services> #{_service.class} #{_service.version}"
        ACTIVE << _service
      end
    end

    # Tells all services that have 'client_connected' defined that 'client_id' has connected
    # @param client_id [Integer] ID of client
    # @param ip_address [String] ip address of client
    def self.client_connected(client_id, ip_address)
      ACTIVE.each do |service|
        service.client_connected(client_id, ip_address) if defined?(service.client_connected)
      end
    end

    # Tells all services that have 'client_disconnected' defined that 'client_id' is now disconnected
    # @param client_id [Integer] ID of client
    def self.client_disconnected(client_id)
      ACTIVE.each do |service|
        service.client_disconnected(client_id) if defined?(service.client_disconnected)
      end
    end
  end
end
