module GameOverseer
  class HandShake

    # OpenSSL Public/Private Key Encryption For Initial Handshaking And Authentication Masking.
    def self.generate
      @keys = OpenSSL::PKey::RSA.new 512
    end

    def self.public_key
      generate unless defined?(@keys)
      @keys.public_key.to_pem
    end

    def self.keys
      generate unless defined?(@keys)
      @keys
    end
  end
end
