# RPC server for a tem_multi_proxy server.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Massachusetts Institute of Technology
# License:: MIT

require 'logger'
require 'rbtree'
require 'set'


# :nodoc: namespace
module Tem::MultiProxy
 
# RPC server for a tem_multi_proxy server.
#
# The server's RPC interface provides administrative information about the cards
# connected to it. To communicate with the smart-cards, use the transports in
# the smartcard gem (see the Smartcard::Iso namespace).
class Server
  DEFAULT_PORT = 9051

  Protocol = Zerg::Support::Protocols::ObjectProtocol
  Adapter = Zerg::Support::Sockets::ProtocolAdapter.adapter_module Protocol 
  SocketFactory = Zerg::Support::SocketFactory
  
  def initialize(server_port = nil)
    @manager = Manager.new
    @socket = SocketFactory.socket :in_port => (server_port || DEFAULT_PORT),
                                   :no_delay => true    
  end
  
  # The main server loop.
  def serving_loop
    Thread.new { socket_loop }
    @manager.management_loop
  end
  
  # Socket-serving loop that takes in clients and spins off a thread for each
  # client.
  def socket_loop
    @socket.listen
    loop do
      client_socket, client_addr = @socket.accept
      Thread.new(client_socket) { |client_socket| serve_client client_socket }      
    end
    @manager.tem_ports
  end
  
  # Handle a single client.
  def serve_client(client)
    client.extend Adapter
    request = client.recv_object
    if request
      case request[:query]
      when 'tem_ports'
        client.send_object @manager.tem_ports
      else
        client.send_object 'Unknown request'
      end
    end
    client.close rescue nil
  end
end

end  # namespace Tem::MultiProxy
