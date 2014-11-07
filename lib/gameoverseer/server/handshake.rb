module GameOverSeer
  class HandShake
    def initialize
      # Do Stuff

      # OpenSSL Public/Private Key Encryption For Initial Handshaking And Password Masking.
      keys = OpenSSL::PKey::RSA.new 512
      p string = keys.public_encrypt("String")
      p keys.private_decrypt(string)
    end
  end
end
