require 'socket'

socket = TCPSocket.open("127.0.0.1", 8080)  # Connect to server

ROWCOUNT = 9
COLCOUNT = 21

sleepTime = ARGV[0]
previousRow = 0
previousCol = 0

sleepTime = 0.1 if sleepTime == nil

socket.print("#{previousRow} #{previousCol} 100\r\n")
socket.flush
sleep sleepTime

while (true)    
  rowMove = previousRow
  colMove = previousCol
  
  rowMoves = [0]
  
  rowMoves << 1 if (rowMove + 1 < ROWCOUNT)
  rowMoves << -1 if (rowMove - 1 >= 0)
    
  colMoves = [0]
  
  colMoves << 1 if (colMove + 1 < COLCOUNT)
  colMoves << -1 if (colMove - 1 >= 0)
    
  rowMove = rowMove + rowMoves[rand(rowMoves.size)]
  colMove = colMove + colMoves[rand(colMoves.size)]
  
  socket.print("#{previousRow} #{previousCol} 0\r\n")
  socket.flush
  
  previousRow = rowMove
  previousCol = colMove
  
  socket.print("#{previousRow} #{previousCol} 100\r\n")
  socket.flush
  sleep sleepTime
end