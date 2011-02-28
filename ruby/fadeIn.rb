require 'socket'

socket = TCPSocket.open("127.0.0.1", 8080)  # Connect to server

sleepTime = ARGV[0]

sleepTime = 0.1 if sleepTime == nil

for brightness in 0..100 do
  for index in 0..189 do
    socket.print("#{index} #{brightness}\r\n")
    socket.flush
  end
  sleep sleepTime.to_f
end