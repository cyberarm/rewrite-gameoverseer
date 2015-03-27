# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gameoverseer/version"

Gem::Specification.new do |s|
  s.name = "gameoverseer"
  s.version = GameOverseer::VERSION
  s.authors = ["Cyberarm"]
  s.email = ["matthewlikesrobots@gmail.com"]
  s.homepage = "https://github.com/cyberarm/rewrite-gameoverseer"
  s.summary = "Generic game server."
  s.description = "GameOverseer is designed to simplify the making of multiplayer games by providing a way to simply and easily write a game server."

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib", "bin"]

  s.add_runtime_dependency "gosu"
  s.add_runtime_dependency "celluloid"
  s.add_runtime_dependency "renet"
  s.add_runtime_dependency "multi_json"

  # s.add_development_dependency "simplecov"
end
