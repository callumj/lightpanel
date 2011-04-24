require 'socket'

def to_bool(value)
  return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
end

class Panel
  NUMROWS = 9
  NUMCOLS = 21
  MAXINDEX = NUMCOLS * NUMROWS
  
  attr_accessor :threads
  
  def initialize(args = nil)
    
    args = {:server => "127.0.0.1", :port => 8080} if (args == nil)
    
    @socket = TCPSocket.open(args[:server], args[:port])
    @threads = []
    
    loadExtensions
  end
  
  def loadExtensions
    Dir[File.dirname(__FILE__) + '/extensions/*.rb'].each do |file| 
      require File.dirname(__FILE__) + "/extensions/" + File.basename(file, File.extname(file))
    end
  end
  
  def sendCommand(command)
    @socket.print("#{command}\r\n")
    @socket.flush
  end
  
  def set(args)
    return if (args == nil || !(args.has_key?(:brightness)))
    
    if (args.has_key?(:row) && args.has_key?(:col))
      sendCommand("#{args[:row]} #{args[:col]} #{args[:brightness]}")
    elsif (args.has_key?(:index))
      sendCommand("#{args[:index]} #{args[:brightness]}")
    end
  end
  
  def allOn()
    for row in 0..NUMROWS
      for col in 0..NUMCOLS
        set(:row => row, :col => col, :brightness => 100)
      end
    end
  end
  
  def allOff()
    for row in 0..NUMROWS
      for col in 0..NUMCOLS
        set(:row => row, :col => col, :brightness => 0)
      end
    end
  end
  
  
  #Thread based functions
  def stop(args = nil)
    return if @threads.size == 0
    
    args = {:oldest => true} if args == nil
    
    if (to_bool(args[:oldest]) == true || to_bool(args[:newest]) == true || args[:index] != nil)
      threadToEnd = @threads[0]
      threadToEnd = @threads[@threads.size - 1] if to_bool(args[:newest]) == true
      threadToEnd = @threads[args[:index]] if args[:index] != nil
      
      threadToEnd[:stop] = true if (to_bool(args[:fast]) != true)
      @threads.delete(threadToEnd).kill if (to_bool(args[:fast]) == true)
      return
    end
    
    if (args[:all] == true)
      @threads.each do |runningThread| 
        runningThread[:stop] = true if (to_bool(args[:fast]) != true)
        runningThread.kill if (to_bool(args[:fast]) == true)
      end
      
      @threads.clear if (to_bool(args[:fast]) == true)
    end
  end
  
  def finished(threadObj)
    @threads.delete(threadObj)
  end
  
  def renderArray(args = {})
     return nil if args[:matrix] == nil
     args[:row_offset] = 0 if args[:row_offset] == nil
     args[:col_offset] = 0 if args[:col_offset] == nil
     
     for row in 0..(args[:matrix].size - 1) do
       for col in 0..(args[:matrix][row].size - 1) do
         set(:row => row + args[:row_offset].to_i, :col => col + args[:col_offset].to_i, :brightness => args[:matrix][row][col].to_i)
       end
     end
  end
end