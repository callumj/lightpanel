require 'socket'
require 'json'
load "#{File.dirname(__FILE__)}/Panel.rb"

thepanel = Panel.new
socket = TCPSocket.open("127.0.0.1", 8094)

socket.send("PIN:2045",0)

while line = socket.gets   # Read lines from the socket
  begin
    data = JSON.parse(line)
    if (data != nil && data["event"] != nil)
      data["y"] = data["y"].to_f.round(2)
      data["x"] = data["x"].to_f.round(2)
      thepanel.set(:row => "#{data["y"]}%", :col => "#{data["x"]}%", :brightness => 100)
    end
  rescue
    puts "error"
  end
end