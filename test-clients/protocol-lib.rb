require "multi_json"

PROTOCOLS = {
  # Client
  handshake_extend_hand: MultiJson.dump({'channel' => 'handshake', 'mode' => 'extend_hand'}),
  handshake_authenticate: "{'channel'=> 'handshake', \"mode\": \"authenticate\", \"data\": {\"auth_key\": \"public_key_encrypted_auth_key\"}}",


  # Server
  handshake_public_key: "{\"channel\": \"handshake\", \"mode\": \"public_key\", \"data\": {\"public_key\": \"really_long_string\"}}",
  handshake_authenticated: "{\"channel\": \"handshake\", \"mode\": \"authenticated\", \"data\": {\"code\": 200, \"message\": \"Successfully authenticated.\"}}",
  handshake_bad_authentication: "{\"channel\": \"handshake\", \"mode\": \"bad_authentication\", \"data\": {\"code\": 401, \"message\": \"Could not authenticate.\"}}"
}
