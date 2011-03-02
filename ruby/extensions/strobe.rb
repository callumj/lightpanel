class Panel
  
  def strobe(sleepTime = nil)
    sleepTime = 0.1 if sleepTime == nil
    sleepTime = sleepTime.to_f 
    
    @threads << Thread.new(sleepTime, self) { |sleepTime, thisObj|
        while (true)
          for x in 0..189 do
            thisObj.set(:index => x, :brightness => 100)
          end

          sleep sleepTime.to_f

          for x in 0..189 do
            thisObj.set(:index => x, :brightness => 0)
          end

          sleep sleepTime.to_f
          if (Thread.current[:stop] != nil && Thread.current[:stop] == true)
            thisObj.finished(Thread.current)
            break
          end
        end
      }
  end
end