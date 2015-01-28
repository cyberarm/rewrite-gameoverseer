module GameOverseer
  class ClientManager
    attr_accessor :clients

    def initialize
      ClientManager.instance = self
      @clients = []
    end

    def add(client_id, ip_address)
      @clients << {client_id: client_id, ip_address: ip_address}
      GameOverseer::Services.client_connected(client_id, ip_address)
    end

    def update(client_id, key, value)
      @clients.each_with_index do |hash, index|
        if hash[:client_id] == client_id
          hash[key] = value
        end
      end
    end

    def remove(client_id)
      @clients.each_with_index do |hash, index|
        if hash[:client_id] == client_id
          @clients.delete(hash)
          GameOverseer::Services.client_disconnected(client_id)
        end
      end
    end

    def self.instance
      @instance
    end

    def self.instance=_instance
      @instance = _instance
    end
  end
end
