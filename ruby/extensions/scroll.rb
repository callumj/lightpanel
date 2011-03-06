class Panel
  
  def scroll(sleepTime = nil)
    sleepTime = 0.5 if sleepTime == nil
    sleepTime = sleepTime.to_f 
    
    @threads << Thread.new(sleepTime, self) { |sleepTime, thisObj|        
        while (true)    
          for col in 0..NUMCOLS do
            for row in 0..NUMROWS do
              thisObj.set(:row => row, :col => col, :brightness => 100)
            end
            sleep sleepTime
          end

          for col in 0..NUMCOLS do
            for row in 0..NUMROWS do
              thisObj.set(:row => row, :col => col, :brightness => 0)
            end
            sleep sleepTime
          end
          
          if (Thread.current[:stop] != nil && Thread.current[:stop] == true)
           thisObj.finished(Thread.current)
           break
          end
        end
      }
  end
end