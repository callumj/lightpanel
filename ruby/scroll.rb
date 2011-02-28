require 'socket'

socket = TCPSocket.open("127.0.0.1", 8080)  # Connect to server

sleepTime = ARGV[0]

sleepTime = 0.1 if sleepTime == nil

while (true)

  for col in 0..21 do
    for row in 0..9 do
      socket.print("#{row} #{col} 100\r\n")
      socket.flush
    end
    sleep sleepTime.to_f
  end

  for col in 0..21 do
    for row in 0..9 do
      socket.print("#{row} #{col} 0\r\n")
      socket.flush
    end
    sleep sleepTime.to_f
  end
end