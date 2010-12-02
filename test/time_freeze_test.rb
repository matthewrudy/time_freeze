require 'test_helper'
require 'time'
require 'date'

class TimeFreezeTest < Test::Unit::TestCase
  
  def setup
    @time_now = Time.now
  end
  
  def test_normal_function
     time_before = Time.now
     datetime_before = DateTime.now
     date_before = Date.today
     
     sleep 10
     
     assert_in_delta 10, Time.now - time_before, 0.1
     
     second_of_day = 1.0 / 24 / 60 / 60 
     assert_in_delta 10*second_of_day, DateTime.now - datetime_before, 0.1*second_of_day
     assert_equal date_before, Date.today
   end
  
  def test_freeze!
    freeze_to = Time.mktime(2001,12,30,13,45,59,999999)
    TimeFreeze.freeze!(freeze_to) do
      assert_equal freeze_to, TimeFreeze.frozen_time
      assert_equal freeze_to, Time.now
      assert_equal freeze_to.to_datetime, DateTime.now
      assert_equal freeze_to.to_date, Date.today
    end
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
  
  def assert_unfrozen_time
    assert_in_delta 0, Time.now - @time_now, 0.5
    
    second_of_day = 1.0 / 24 / 60 / 60 
    assert_in_delta 0, DateTime.now - @time_now.to_datetime, 0.5*second_of_day
    
    assert_equal @time_now.to_date, Date.today
  end
  
end
      