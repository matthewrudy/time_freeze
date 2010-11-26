class Time
  
  # stolen from ActiveSupport...
  # but I don't want to require ActiveSupport
  
  # Converts a Time object to a Date, dropping hour, minute, and second precision.
  #
  #   my_time = Time.now  # => Mon Nov 12 22:59:51 -0500 2007
  #   my_time.to_date     # => Mon, 12 Nov 2007
  #
  #   your_time = Time.parse("1/13/2009 1:13:03 P.M.")  # => Tue Jan 13 13:13:03 -0500 2009
  #   your_time.to_date                                 # => Tue, 13 Jan 2009
  def to_date
    ::Date.new(year, month, day)
  end unless method_defined?(:to_date)

  # A method to keep Time, Date and DateTime instances interchangeable on conversions.
  # In this case, it simply returns +self+.
  def to_time
    self
  end unless method_defined?(:to_time)

  # Converts a Time instance to a Ruby DateTime instance, preserving UTC offset.
  #
  #   my_time = Time.now    # => Mon Nov 12 23:04:21 -0500 2007
  #   my_time.to_datetime   # => Mon, 12 Nov 2007 23:04:21 -0500
  #
  #   your_time = Time.parse("1/13/2009 1:13:03 P.M.")  # => Tue Jan 13 13:13:03 -0500 2009
  #   your_time.to_datetime                             # => Tue, 13 Jan 2009 13:13:03 -0500
  def to_datetime
    ::DateTime.civil(year, month, day, hour, min, sec, Rational(utc_offset, 86400))
  end unless method_defined?(:to_datetime)
  
end
