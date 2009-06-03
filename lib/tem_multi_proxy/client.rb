# :nodoc: namespace
module Tem::MultiProxy
  
class Client
  Protocol = Zerg::Support::Protocols::ObjectProtocol
  Adapter = Zerg::Support::Sockets::ProtocolAdapter.adapter_module Protocol 
  SocketFactory = Zerg::Support::SocketFactory
  JcopRemoteTransport = Tem::Transport::JcopRemoteTransport 
  
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
end

end  # namespace Tem::MultiProxy
