require 'test_helper'
require 'time'
require 'date'

class TimeFreezeTest < Test::Unit::TestCase
  
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
    time_now  = Time.now
    freeze_to = Time.mktime(2001,12,30,13,45,59,999999)
    begin
      TimeFreeze.freeze!(freeze_to) do
        assert_equal freeze_to, Time.now
        assert_equal freeze_to.to_datetime, DateTime.now
        assert_equal freeze_to.to_date, Date.today

        raise ExampleRaisedException

        flunk "we seem to have resumed after the raise"
      end

    rescue ExampleRaisedException

      assert_not_equal freeze_to, Time.now
      assert_not_equal freeze_to.to_datetime, DateTime.now
      assert_not_equal freeze_to.to_date, Date.today
    end

    assert_equal time_now.to_date, Date.today
  end
  
  def test_nested_freeze
    time_now  = Time.now
    freeze_to1 = Time.mktime(2001,12,30,13,45,59,999999)
    freeze_to2 = Time.mktime(2015,03,16,23,22,13,764282)
    
    TimeFreeze.freeze!(freeze_to1) do
      assert_equal freeze_to1, Time.now
      assert_equal freeze_to1.to_datetime, DateTime.now
      assert_equal freeze_to1.to_date, Date.today
      
      TimeFreeze.freeze!(freeze_to2) do
        assert_equal freeze_to2, Time.now
        assert_equal freeze_to2.to_datetime, DateTime.now
        assert_equal freeze_to2.to_date, Date.today
      end
      
      assert_equal freeze_to1, Time.now
      assert_equal freeze_to1.to_datetime, DateTime.now
      assert_equal freeze_to1.to_date, Date.today
    end
  end    
  
end
      