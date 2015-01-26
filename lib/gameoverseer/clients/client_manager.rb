module GameOverseer
  class ClientManager
    attr_accessor :clients

    def initialize
      ClientManager.instance = self
      @clients = []
    end

    def add(id, ip_address)
      @clients << {id: id, ip_address: ip_address}
    end

    def update(id, key, value)
      @clients.each_with_index do |hash, index|
        if hash[:id] == id
          hash[key] = value
        end
      end
    end

    def remove(id)
      @clients.each_with_index do |hash, index|
        if hash[:id] == id
          @clients.delete(hash)
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
