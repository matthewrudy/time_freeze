require 'time_freeze/time_extensions'

module TimeFreeze
  
  @@frozen_time = nil
  
  def self.frozen_time
    @@frozen_time
  end
  
  def self.frozen_time=(value)
    @@frozen_time = value
  end
  
  def self.freeze!(frozen_time=Time.now)
    raise ArgumentError, "we can only freeze to a Time" unless frozen_time.is_a?(Time)
    TimeFreeze.frozen_time, time_before = frozen_time, TimeFreeze.frozen_time
    yield
  ensure
    # no matter what happens
    # we need to reset this
    TimeFreeze.frozen_time = time_before
  end
  
  def self.unfreeze!
    self.frozen_time=nil
  end
  
  module FreezeTime
    
    def now
      TimeFreeze.frozen_time.to_time || super()
    end
    
  end
  
  module FreezeDate
    
    def today
      TimeFreeze.frozen_date.to_date || super()
    end
    
  end
  
  module FreezeDateTime
    
    def now
      TimeFreeze.frozen_datetime.to_datetime || super()
    end
    
  end
  
end

class Time
  extend TimeFreeze::FreezeTime
end

if defined?(Date)
  
  class Date
    extend TimeFreeze::FreezeDate
  end
  
end

if defined?(DateTime)
  
  class DateTime
    extend TimeFreeze::FreezeDateTime
  end
  
end