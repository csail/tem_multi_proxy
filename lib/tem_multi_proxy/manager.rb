require 'logger'
require 'rbtree'
require 'set'


# :nodoc: namespace
module Tem::MultiProxy  

class Manager
  def initialize
    @pcsc_context = Smartcard::PCSC::Context.new(Smartcard::PCSC::SCOPE_SYSTEM)
    @proxy_pids = {}
    @proxy_ports = {}
    @free_ports = RBTree.new
    (9001...9050).each { |port| @free_ports[port] = true }
    @logger = Logger.new STDERR
  end

  # Polls each smartcard reader to see if there's a card present.
  def poll_readers
    readers = @pcsc_context.list_readers(nil).map { |name| { :name => name }}
    reader_states = Smartcard::PCSC::ReaderStates.new readers.length
    readers.each_with_index do |reader, i|
      reader_states.set_reader_name_of!(i, reader[:name])
      reader_states.set_current_state_of!(i, Smartcard::PCSC::STATE_UNAWARE)      
    end    
    @pcsc_context.get_status_change reader_states, 100
    
    readers.each_with_index do |reader, i|
      reader[:atr] = reader_states.atr_of i
      # current_state_of is buggy on pcsclite, using the ATR for card detection.
      if reader[:atr].length == 0
        reader[:card] = false
        reader[:atr] = nil
      else
        reader[:card] = true
      end
    end
    
    readers
  end
    
  # Allocates a port for a TEM proxy.
  def alloc_proxy_port(reader_name)
    port = @free_ports.min.first
    @free_ports.delete port
    @proxy_ports[reader_name] = port
    port
  end
  
  # Marks a TEM proxy port as free.
  def free_proxy_port(reader_name)
    port = @proxy_ports[reader_name]
    return unless port
    @proxy_ports.delete reader_name
    @free_ports[port] = true
  end

  # Launches a tem_proxy process connecting to a reader.
  def spawn_proxy_for_reader(reader)
    proxy_port = alloc_proxy_port reader[:name]
    proxy_pid = Zerg::Support::Process.spawn 'tem_proxy', [proxy_port.to_s],
        :env => {'TEM_PORT' => reader[:name], 'DEBUG' => 'no'},
        :pgroup => true
    @proxy_pids[reader[:name]] = proxy_pid
  end
  
  # Updates the internal status to reflect that a tem_proxy process died. 
  def proxy_died(reader_name)
    free_proxy_port reader_name
    @proxy_pids.delete reader_name
  end
  
  # Kills the tem_proxy process for a reader.
  def kill_proxy(reader_name)
    if proxy_pid = @proxy_pids[reader_name]
      Zerg::Support::Process.kill_tree proxy_pid
    end
    proxy_died reader_name
  end
  
  # Kills all the proxy processes.
  def kill_all_proxies
    processes = Zerg::Support::Process.processes
    processes.each do |proc_info|
      next unless /tem_proxy/ =~ proc_info[:command_line]
      @logger.info "Mass-killing TEM proxy (pid #{proc_info[:pid]})"
      Zerg::Support::Process::kill_tree proc_info[:pid]
    end
  end  
  
  # Synchronizes the running tem_proxy processes with the list of readers.  
  def sync_reader_proxies
    processes = Zerg::Support::Process.processes_by_id
    # Check for crashed tem_proxy processes.
    @proxy_pids.each do |reader_name, pid|
      proc_info = processes[pid]
      unless proc_info and /tem_proxy/ =~ proc_info[:command_line]
        @logger.warn "TEM proxy for #{reader_name} (pid #{pid}) died."
        proxy_died reader_name
      end
    end

    live_readers = poll_readers.select { |reader| reader[:card] }
    # Kill proxies whose readers aren't available.
    live_reader_names = Set.new live_readers.map { |reader| reader[:name] }
    @proxy_pids.keys.each do |reader_name|
      next if live_reader_names.include? reader_name
      @logger.info "Killing TEM proxy for #{reader_name}. " +
                   "(pid #{@proxy_pids[reader_name]})"
      kill_proxy reader_name
    end
    
    # Spawn proxies for readers without them.
    live_readers.each do |reader|
      next if @proxy_pids[reader[:name]]
      @logger.info "Spawning new TEM proxy for #{reader[:name]}."
      spawn_proxy_for_reader reader
    end
  end
  
  # Never-ending loop mananging TEM proxies for all the readers.
  def management_loop
    kill_all_proxies
    loop do
      sync_reader_proxies
      Kernel.sleep 1
    end
  end
end

end  # namespace Tem::MultiProxy
