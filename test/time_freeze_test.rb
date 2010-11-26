require 'test_helper'
require 'time'
require 'date'

class TimeFreezeTest < Test::Unit::TestCase
  
  def test_normal_function
    time_now = Time.now
    sleep 10
    assert ((time_now+10)..(time_now+11)).include?(Time.now)
    
    assert_equal time_now.to_date, Date.today
    assert_equal Time.now.to_datetime, DateTime.now
  end
  
  def test_freeze!
    freeze_to = Time.mktime(2001,12,30,13,45,59,999999)
    TimeFreeze.freeze!(freeze_to) do
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
  
end
      