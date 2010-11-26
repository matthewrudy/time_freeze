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
      if TimeFreeze.frozen_time
        TimeFreeze.frozen_time.to_time
      else
        super()
      end
    end
    
  end
  
  module FreezeDate
    
    def today
      if TimeFreeze.frozen_time
        TimeFreeze.frozen_time.to_date
      else
        super()
      end
    end
    
  end
  
  module FreezeDateTime
    
    def now
      if TimeFreeze.frozen_time
        TimeFreeze.frozen_time.to_datetime
      else
        super()
      end
    end
    
  end
  
end

class Time
  class << self
    include TimeFreeze::FreezeTime
  end
end

class Date
  class << self
    include TimeFreeze::FreezeDate
  end
end

class DateTime
  class << self
    include TimeFreeze::FreezeDateTime
  end
end
