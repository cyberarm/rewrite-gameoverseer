require "celluloid/io"
require "multi_json"
require "net/ssh"
require 'uri'
require_relative "protocol-lib"

class TestClientBeta
  include Celluloid::IO
  finalizer :finish

  def initialize(host, port)
    @client = Celluloid::IO::TCPSocket.new(host, port)
    run
  end

  def run
    @client.puts("#{PROTOCOLS[:handshake_extend_hand]}")
    line = @client.gets
    p line
    response = MultiJson.load(line)
    public_key_pem = response['data']['public_key'] if response['mode'] == 'public_key'
     public_key = OpenSSL::PKey::RSA.new public_key_pem
    encrypted_auth_key_response = MultiJson.dump({'channel'=> 'handshake', 'mode' => 'authenticate', 'data' => {'auth_key' => "#{public_key.public_encrypt('HELLO_WORLD')}".force_encoding("utf-8")}})
    p encrypted_auth_key_response
    @client.puts("#{encrypted_auth_key_response.inspect}")
  end

  def finish
    @client.close if @client
  end
end

start_time = Time.now

  TestClientBeta.supervise("127.0.0.1", 56789)

puts "Time to complete: #{Time.now-start_time}"
