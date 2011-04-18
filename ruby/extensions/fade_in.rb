class Panel
  
  def fade_in(args = {})
    sleepTime = args[:sleep_time]
    sleepTime = 0.5 if sleepTime == nil
    sleepTime = sleepTime.to_f 
    
    @threads << Thread.new(sleepTime, self) { |sleepTime, thisObj|        
        while (true)
          for brightness in 0..100
            for col in 0..NUMCOLS do
              for row in 0..NUMROWS do
                thisObj.set(:row => row, :col => col, :brightness => brightness)
              end
            end
          end
          
          sleep sleepTime
          
          for brightness in 0..100
            brightness = brightness - 100;
            brightness = brightness.abs
            for col in 0..NUMCOLS do
              for row in 0..NUMROWS do
                thisObj.set(:row => row, :col => col, :brightness => brightness)
              end
            end
          end
          
          sleep sleepTime
          
          if (Thread.current[:stop] != nil && Thread.current[:stop] == true)
           thisObj.finished(Thread.current)
           break
          end
        end
      }
  end
end