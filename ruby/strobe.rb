require 'socket'

socket = TCPSocket.open("127.0.0.1", 8080)  # Connect to server

sleepTime = ARGV[0]

sleepTime = 0.1 if sleepTime == nil

while (true)
  for x in 0..189 do
    socket.print("#{x} 100\r\n")
    socket.flush
  end
  
  sleep sleepTime.to_f
  
  for x in 0..189 do
    socket.print("#{x} 0\r\n")
    socket.flush
  end
  
  sleep sleepTime.to_f
end