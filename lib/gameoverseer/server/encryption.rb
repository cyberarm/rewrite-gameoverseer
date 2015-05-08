module GameOverseer
  module Encryption

    # OpenSSL Public/Private Key Encryption For Initial Handshaking And Authentication Masking.
    def generate(size = 512)
      @openssl_keys = OpenSSL::PKey::RSA.new(size)
    end

    def public_key
      generate unless defined?(@openssl_keys)
      @openssl_keys.public_key.to_pem
    end

    def openssl_keys
      generate unless defined?(@openssl_keys)
      @openssl_keys
    end

    # return encrypted string
    def encrypt(string)
      generate unless defined?(@openssl_keys)
      @openssl_keys.private_encrypt(string)
    end

    # return decrypted string
    def decrypt(string)
      generate unless defined?(@openssl_keys)
      @openssl_keys.public_decrypt(string)
    end
  end
end
