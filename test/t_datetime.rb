$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

class DistanceOfTimeTest < Test::Unit::TestCase
  def test_distance_of_time_in_words
    assert_equal "меньше минуты", RuTils::DateTime::distance_of_time_in_words(0, 50)
    assert_equal "2 минуты", RuTils::DateTime::distance_of_time_in_words(0, 140)
    assert_equal "около 2 часов", RuTils::DateTime::distance_of_time_in_words(0, 60*114)
    assert_equal "около 3 часов", RuTils::DateTime::distance_of_time_in_words(0, 60*120+60*60)
    assert_equal "около 5 часов", RuTils::DateTime.distance_of_time_in_words(60*60*5) 
  end
end

class StrftimeRuTest < Test::Unit::TestCase
  def test_strftime_ru
    @@old_overrides = RuTils::overrides_enabled?
    
    RuTils::overrides = true
      assert_equal "сб, суббота, дек, декабрь", Time.local(2005,"dec",31).strftime("%a, %A, %b, %B")
      assert_equal "%a, %A, %b, %B", Time.local(2005,"dec",31).strftime("%%a, %%A, %%b, %%B")
      assert_equal "%сб, %суббота, %дек, %декабрь", Time.local(2005,"dec",31).strftime("%%%a, %%%A, %%%b, %%%B")
      assert_equal "Сегодня: 31 декабря, суббота, 2005 года", Time.local(2005,"dec",31).strftime("Сегодня: %d %B, %A, %Y года")
      assert_equal "Сегодня: ноябрь, 30 число, дождик в четверг, а год у нас - 2006", Time.local(2006,11,30).strftime("Сегодня: %B, %d число, дождик в %A, а год у нас - %Y")
      
      date = Date.new(2005, 12, 31)
      assert_equal "дек декабрь сб суббота", "#{Date::RU_ABBR_MONTHNAMES[date.mon]} #{Date::RU_MONTHNAMES[date.mon]} #{Date::RU_ABBR_DAYNAMES[date.wday]} #{Date::RU_DAYNAMES[date.wday]}"
      # We do not support strftime on date at this point
      # assert_equal "сб, суббота, дек, декабрь", date.strftime("%a, %A, %b, %B")
    
    RuTils::overrides = false
      assert_equal "Sat, Saturday, Dec, December", Time.local(2005,"dec",31).strftime("%a, %A, %b, %B")
      assert_equal "%a, %A, %b, %B", Time.local(2005,"dec",31).strftime("%%a, %%A, %%b, %%B")
      assert_equal "%Sat, %Saturday, %Dec, %December", Time.local(2005,"dec",31).strftime("%%%a, %%%A, %%%b, %%%B")
      assert_equal "Сегодня: 31 December, Saturday, 2005 год", Time.local(2005,"dec",31).strftime("Сегодня: %d %B, %A, %Y год")
      
      date = Date.new(2005, 11, 9)
      assert_equal "Nov November Wed Wednesday", "#{Date::ABBR_MONTHNAMES[date.mon]} #{Date::MONTHNAMES[date.mon]} #{Date::ABBR_DAYNAMES[date.wday]} #{Date::DAYNAMES[date.wday]}"
    
    RuTils::overrides = @@old_overrides
  end
end
