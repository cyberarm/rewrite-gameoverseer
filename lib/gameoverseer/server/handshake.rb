module GameOverseer
  class HandShake
    def self.generate
      # Do Stuff

      # OpenSSL Public/Private Key Encryption For Initial Handshaking And Password Masking.
      @keys = OpenSSL::PKey::RSA.new 512
    end

    def self.public_key
      generate unless defined?(@keys)
      @keys.public_key.to_pem
    end
  end
end
