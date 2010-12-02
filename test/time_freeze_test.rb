require 'test_helper'
require 'time'
require 'date'

class TimeFreezeTest < Test::Unit::TestCase
  
  def setup
    @time_now     = Time.now
    @datetime_now = DateTime.now
    @date_today    = Date.today
    
    TimeFreeze.unfreeze!
  end
  
  def test_normal_function
     assert_unfrozen_time
     
     sleep 10
     
     assert_unfrozen_time(10)
   end
  
  def test_freeze!
    time1 = Time.mktime(2001,12,30,13,45,59,999999)
    
    assert_unfrozen_time
    
    TimeFreeze.freeze!(time1) do
      assert_frozen_time(time1)
    end
    
    assert_unfrozen_time
  end
  
  class ExampleRaisedException < Exception; end
  
  def test_freeze_unfreezes_after_exception
   time1 = Time.mktime(2001,12,30,13,45,59,999999)
    
    assert_unfrozen_time
    
    begin
      TimeFreeze.freeze!(time1) do
        
        assert_frozen_time(time1)

        raise ExampleRaisedException

        flunk "we seem to have resumed after the raise"
      end

    rescue ExampleRaisedException

      assert_unfrozen_time
      
    end

    assert_unfrozen_time
  end
  
  def test_nested_freeze
    time1 = Time.mktime(2001,12,30,13,45,59,999999)
    time2 = Time.mktime(2015,03,16,23,22,13,764282)
    
    assert_unfrozen_time
    
    TimeFreeze.freeze!(time1) do
      assert_frozen_time(time1)
      
      TimeFreeze.freeze!(time2) do
        assert_frozen_time(time2)
      end
      
      assert_frozen_time(time1)
    end
    
    assert_unfrozen_time
  end
  
  def assert_frozen_time(expected_time)
    assert_equal TimeFreeze.frozen_time,    expected_time
    assert_equal expected_time,             Time.now
    assert_equal expected_time.to_datetime, DateTime.now
    assert_equal expected_time.to_date,     Date.today
  end
  
  def assert_unfrozen_time(offset=0)
    assert_in_delta offset, Time.now - @time_now, 0.5
    assert_in_delta offset*DateTime::SECONDS_IN_DAY, DateTime.now - @datetime_now, 0.5*DateTime::SECONDS_IN_DAY
    
    assert_equal @date_today, Date.today
  end
  
end
      