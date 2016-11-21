module GameOverseer

  # Stores client data
  class ClientManager
    attr_accessor :clients

    def initialize
      ClientManager.instance = self
      @clients = []
    end

    # Add client to clients list
    # @param client_id [Integer]
    # @param ip_address [String]
    def add(client_id, ip_address)
      @clients << {client_id: client_id, ip_address: ip_address}
      GameOverseer::Services.client_connected(client_id, ip_address)
      GameOverseer::Console.log("ClientManager> client with id '#{client_id}' connected")
    end

    # Store client specific data in a {Hash}
    # @param client_id [Integer] ID of client
    # @param key [String|Symbol]
    # @param value What the key should equal
    def update(client_id, key, value)
      @clients.each do |hash|
        if hash[:client_id] == client_id
          hash[key] = value
        end
      end
    end

    # Gets client data
    # @param client_id [Integer]
    # @return [Hash] hash containing client data
    def get(client_id)
      _hash = @clients.detect do |hash|
        if hash[:client_id] == client_id
          true
        end
      end

      return _hash
    end

    # Removes client data and disconnects client
    # @param client_id [Integer] ID of client
    def remove(client_id)
      @clients.each do |hash|
        if hash[:client_id] == client_id
          @clients.delete(hash)
          GameOverseer::Services.client_disconnected(client_id)
          GameOverseer::Console.log("ClientManager> client with id '#{client_id}' disconnected")
        end
      end
    end

    # @return [ClientManager]
    def self.instance
      @instance
    end

    # @param _instance [ClientManager]
    def self.instance=_instance
      @instance = _instance
    end
  end
end
