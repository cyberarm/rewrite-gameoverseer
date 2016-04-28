module GameOverseer
  class EncryptionHandler

    def initialize(key_size: 128, keypair_size: 2048)
      EncryptionHandler.instance = self
      generate_server_keypair(keypair_size)
    end

    def generate_server_keypair(keypair_size)
      @server_keypair = OpenSSL::PKey::RSA.generate(keypair_size)
    end

    def encrypt_keypair(client_id, string)
    end

    def decrypt_keypair(string)
    end

    def encrypt(client_id, string)
    end

    def decrypt(client_id, string)
    end

    def set_client_keypair(client_id, public_key_pem)
    end

    def set_client_key(client_id)
      ClientManager.instance.update(client_id, '_aes_key', 'In progress, not ready.')
    end

    def self.instance
      @instance
    end

    def self.instance=(_instance)
      @instance = _instance
    end
  end
end
