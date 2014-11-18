require "celluloid/io"
require "multi_json"
require "net/ssh"
require_relative "protocol-lib"

class TestClientAlpha
  include Celluloid::IO
  finalizer :finish

  def initialize(host, port)
    @client = UDPSocket.new
    @client.connect(host, port)
    run
  end

  def run
    @client.send("#{PROTOCOLS[:handshake_extend_hand]}", 0)
    socket = @client.recvfrom(1024)
    response = MultiJson.load(socket[0])
    public_key_pem = response['data']['public_key'] if response['mode'] == 'public_key'
     public_key = OpenSSL::PKey::RSA.new public_key_pem
    encrypted_auth_key_response = MultiJson.dump({'channel'=> 'handshake', 'mode' => 'authenticate', 'data' => {'auth_key' => "#{public_key.public_encrypt('HELLO_WORLD')}"}})
    p encrypted_auth_key_response
    @client.send("#{encrypted_auth_key_response}", 0)
  end

  def finish
    @client.close if @client
  end
end

start_time = Time.now

  TestClientAlpha.supervise('localhost', 56789)

puts "Time to complete: #{Time.now-start_time}"
