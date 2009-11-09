# Main include file for the tem_multi_proxy Rubygem.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Massachusetts Institute of Technology
# License:: MIT

# Gem requirements.
require 'rubygems'
require 'smartcard'
require 'zerg_support'

# :nodoc: namespace
module Tem  
end

# The files making up the gem.
require 'tem_multi_proxy/client.rb'
require 'tem_multi_proxy/manager.rb'
require 'tem_multi_proxy/server.rb'
