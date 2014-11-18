# GameOverseer
A game server, designed to be able to play host to up to 4 players in Planet Wars.

This repo is a complete rewrite of  [GameOverseer](https://github.com/cyberarm/gameoverseer).

# Status
In development.
Any examples given are subject to be outdated at anytime.

# Install

# Usage
``` ruby
require 'gameoverseer'

# Write a service for your game
class GameWorld < GameOverseer::Service
  def setup
    channel_manager.register('game_world')
  end

  def process(data)
    # Do stuff with the data hash.
  end

  def version
    "1.3.75"
  end
end

host = "localhost"
port = 56789
GameOverseer.activate(host, port)
```
