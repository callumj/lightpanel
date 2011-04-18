class Panel
  
  def random_dots(args = {})
    sleepTime = args[:sleep_time]
    sleepTime = 0.5 if sleepTime == nil
    sleepTime = sleepTime.to_f
    indexTrack = []
    
    @threads << Thread.new(sleepTime, self) { |sleepTime, thisObj|        
        while (true)
          targetIndex = rand(MAXINDEX)
          
          if (indexTrack[targetIndex] == true)
            thisObj.set(:index => targetIndex, :brightness => 0)
            indexTrack[targetIndex] = false
          else
            thisObj.set(:index => targetIndex, :brightness => 100)
            indexTrack[targetIndex] = true
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