require 'test_helper'

class TimeFreezeTest < Test::Unit::TestCase
  
  test "normal function" do
    time_now = Time.now
    sleep 10
    assert ((time_now+10)..(time_now+11)).include?(Time.now)
    
    assert_equal time_now.to_date, Date.today
    assert_equal Time.now.to_datetime, DateTime.now
  end
  
  test "freeze!" do
    time1 = Time.mktime(2001,12,23,34,45)
    date1 = Date.new(2001,12,23)
    TimeFreeze.freeze!(time1) do
      assert_equal time1, Time.now
      assert_equal time1.to_datetime, DateTime.now
      assert_equal date1, Date.today
    end
  end
  
  class ExampleRaisedException < Exception; end
  
  test "freeze! - unfreezes, even if an exception is raise" do
    
    time_now  = Time.now
    freeze_to = Time.mktime(2001,12,23,34,45)
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
  end
  
end
    
      