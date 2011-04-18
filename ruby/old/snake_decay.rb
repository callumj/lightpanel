require 'socket'

socket = TCPSocket.open("127.0.0.1", 8080)  # Connect to server

ROWCOUNT = 9
COLCOUNT = 21

sleepTime = ARGV[0]
previousRow = 0
previousCol = 0
previousTailStack = Array.new

sleepTime = 0.1 if sleepTime == nil

socket.print("#{previousRow} #{previousCol} 100\r\n")
socket.flush
sleep sleepTime.to_f

while (true)    
  rowMove = previousRow
  colMove = previousCol
  
  rowMoves = [0]
  
  rowMoves << 1 if (rowMove + 1 < ROWCOUNT)
  rowMoves << -1 if (rowMove - 1 >= 0)
    
  colMoves = [0]
  
  colMoves << 1 if (colMove + 1 < COLCOUNT)
  colMoves << -1 if (colMove - 1 >= 0)
  
  rowIncr = rowMoves[rand(rowMoves.size)]
  colIncr = colMoves[rand(colMoves.size)]
  
  #Don't want to go sideways
  if (rowIncr == colIncr)
    choice = rand(1)
    if (choice == 1)
      colMoves.delete(colIncr)
      colIncr = colMoves[rand(colMoves.size)]
    else
      rowMoves.delete(rowIncr)
      rowIncr = rowMoves[rand(rowMoves.size)]
    end
  end
  
  rowMove = rowMove + rowIncr
  colMove = colMove + colIncr
  
  #Manage decay of the tail
  
  previousTailStack << [previousRow, previousCol, 100]
  for previousIndex in previousTailStack
    previousIndex[2] = previousIndex[2] - 25
    
    socket.print("#{previousIndex[0]} #{previousIndex[1]} #{previousIndex[2]}\r\n")
    socket.flush
    previousTailStack.delete(previousIndex) if previousIndex[2] <= 0
  end
  
  previousRow = rowMove
  previousCol = colMove
  
  socket.print("#{previousRow} #{previousCol} 100\r\n")
  socket.flush
  sleep sleepTime.to_f
end