class Panel
  
  def snake_decay(args = {})
    sleepTime = args[:sleep_time]
    sleepTime = 0.5 if sleepTime == nil
    sleepTime = sleepTime.to_f 
    
    @threads << Thread.new(sleepTime, self) { |sleepTime, thisObj|
        previousRow = 0
        previousCol = 0
        previousTailStack = Array.new

        thisObj.set(:row => previousRow, :col => previousCol, :brightness => 100)
        sleep sleepTime
        
        while (true)    
          rowMove = previousRow
          colMove = previousCol

          rowMoves = [0]

          rowMoves << 1 if (rowMove + 1 < NUMROWS)
          rowMoves << -1 if (rowMove - 1 >= 0)

          colMoves = [0]

          colMoves << 1 if (colMove + 1 < NUMCOLS)
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

            thisObj.set(:row => previousIndex[0], :col => previousIndex[1], :brightness => previousIndex[2])
            previousTailStack.delete(previousIndex) if previousIndex[2] <= 0
          end

          previousRow = rowMove
          previousCol = colMove

          thisObj.set(:row => previousRow, :col => previousCol, :brightness => 100)
          sleep sleepTime
          
          if (Thread.current[:stop] != nil && Thread.current[:stop] == true)
           thisObj.finished(Thread.current)
           break
          end
        end
      }
  end
end