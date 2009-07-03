# Gem requirements.
require 'rubygems'
require 'smartcard'
require 'tem_ruby'
require 'zerg_support'

# :nodoc: namespace
module Tem::MultiProxy  
end

# The files making up the gem.
require 'tem_multi_proxy/client.rb'
require 'tem_multi_proxy/manager.rb'
require 'tem_multi_proxy/server.rb'
