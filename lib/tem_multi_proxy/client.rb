# RPC client for a tem_multi_proxy server.
#
# Author:: Victor Costan
# Copyright:: Copyright (C) 2009 Massachusetts Institute of Technology
# License:: MIT

# :nodoc: namespace
module Tem::MultiProxy


# RPC client for a tem_multi_proxy server.
#
# The client supports the RPC server's interface for obtaining administrative
# information about the cards connected to it. To communicate with the
# smart-cards, use the transports in the smartcard gem (see the Smartcard::Iso
# namespace).
class Client
  Protocol = Zerg::Support::Protocols::ObjectProtocol
  Adapter = Zerg::Support::Sockets::ProtocolAdapter.adapter_module Protocol 
  SocketFactory = Zerg::Support::SocketFactory
  JcopRemoteTransport = Smartcard::Iso::JcopRemoteTransport 
  
  # Queries a multi_proxy for its TEMs, and returns them as transport
  # configurations suitable for Tem::Tem#new.
  def self.query_tems(server_addr = 'localhost')
    @client_socket = SocketFactory.socket :out_addr => server_addr,
                                          :out_port => Server::DEFAULT_PORT,
                                          :no_delay => true
    return nil unless @client_socket
    
    @client_socket.extend Adapter
    @client_socket.send_object :query => 'tem_ports'
    tem_ports = @client_socket.recv_object
    @client_socket.close
    
    return nil unless tem_ports
    server_host = SocketFactory.host_from_address server_addr
    tem_ports.map do |port|
      { :class => JcopRemoteTransport,
        :opts => { :host => server_host, :port => port } }
    end
  end  
end  # class Tem::MultiProxy::Client

end  # namespace Tem::MultiProxy
