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

end

class << Time
  alias :now_unfrozen :now
  def now
    if TimeFreeze.frozen_time
      TimeFreeze.frozen_time.to_time
    else
      self.now_unfrozen
    end
  end
  
  # a handy shortcut to TimeFreeze.freeze!
  def freeze!(*args, &block)
    TimeFreeze.freeze!(*args, &block)
  end
end

class << Date
  alias :today_unfrozen :today
  def today
    if TimeFreeze.frozen_time
      TimeFreeze.frozen_time.to_date
    else
      self.today_unfrozen
    end
  end
end

class << DateTime
  alias :now_unfrozen :now
  def now
    if TimeFreeze.frozen_time
      TimeFreeze.frozen_time.to_datetime
    else
      self.now_unfrozen
    end
  end
end
