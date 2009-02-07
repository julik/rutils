# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rutils'

class DistanceOfTimeTest < Test::Unit::TestCase
  def test_distance_of_time_in_words
    assert_format_eq "меньше минуты", 0, 50
    assert_format_eq "2 минуты", 0, 140
    assert_format_eq "около 2 часов", 0, 60*114
    assert_format_eq "около 3 часов", 0, 60*120+60*60
    assert_format_eq "около 5 часов", 60*60*5 
  end
  
  def assert_format_eq(str, *from_and_distance)
    assert_equal str, RuTils::DateTime.distance_of_time_in_words(*from_and_distance) 
  end
end

class StrftimeRuTest < Test::Unit::TestCase
  
  def test_a_formatter_should_actually_return
    the_fmt = "Это случилось %d %B"
    assert_equal "Это случилось 01 декабря", RuTils::DateTime::ru_strftime(Time.local(1985, "dec", 01), the_fmt)
  end
  
  def test_should_not_touch_double_marks
    assert_format_eq "%a, %A, %b, %B", Time.local(2005,"dec",31), "%%a, %%A, %%b, %%B",
      "Should reduce double marks to single marks with no substitutions"
  end
  
  def test_should_replace_triple_marks
    assert_format_eq "%сб, %суббота, %дек, %декабрь", Time.local(2005,"dec",31), "%%%a, %%%A, %%%b, %%%B",
      "Should reduce triple marks to %formatted"
  end
  
  def test_should_replace_shorthands
    assert_format_eq "сб, суббота, дек, декабрь", Time.local(2005,"dec",31), "%a, %A, %b, %B",
      "Should replace shorthands"
  end
  
  def test_percent_d
    assert_format_eq "01 декабря", Time.local(1985, "dec", 01), "%d %B",
      "Should format %d with leading zero and replace month"
    assert_format_eq "11 декабря", Time.local(1985, "dec", 11), "%d %B",
      "Should format 11 with leading zero and replace month"
  end
  
  def test_percent_e
    assert_format_eq "1 декабря", Time.local(1985, "dec", 01), "%e %B",
      "Should format %e w/o leading zero and replace month"
    assert_format_eq "11 декабря", Time.local(1985, "dec", 11), "%e %B",
      "Should format 11 w/o leading zero and replace month"
  end
  
  def test_all_shorthands
    assert_format_eq "Сегодня: 31 декабря, суббота, 2005 года", Time.local(2005,"dec",31),
      "Сегодня: %d %B, %A, %Y года", "Should format with short format string"
    assert_format_eq "Сегодня: ноябрь, 30 число, дождик в четверг, а год у нас - 2006", Time.local(2006,11,30), 
      "Сегодня: %B, %d число, дождик в %A, а год у нас - %Y", "Should format with long format string"
  end
  
  def test_shorthands_defined
    date = Date.new(2005, 12, 31)
    assert_equal "дек декабрь сб суббота", "#{Date::RU_ABBR_MONTHNAMES[date.mon]} #{Date::RU_MONTHNAMES[date.mon]} #{Date::RU_ABBR_DAYNAMES[date.wday]} #{Date::RU_DAYNAMES[date.wday]}"
    
    date = Date.new(2005, 11, 9)
    assert_equal "Nov November Wed Wednesday", "#{Date::ABBR_MONTHNAMES[date.mon]} #{Date::MONTHNAMES[date.mon]} #{Date::ABBR_DAYNAMES[date.wday]} #{Date::DAYNAMES[date.wday]}"

    # We do not support strftime on date at this point
    # assert_equal "сб, суббота, дек, декабрь", date.strftime("%a, %A, %b, %B")
  end
  
  def test_formatter_should_not_mutate_passed_format_strings
    the_fmt, backup = "Это случилось %d %B", "Это случилось %d %B"
    assert_equal "Это случилось 01 декабря", RuTils::DateTime::ru_strftime(Time.local(1985, "dec", 01), the_fmt)
    assert_equal the_fmt, backup
  end
  
  def test_formatter_should_downagrade_format_strings_to_string
    the_fmt, backup = "Это случилось %d %B", "Это случилось %d %B"
    assert_nothing_raised do
      assert_format_eq "Это случилось 01 декабря", Time.local(1985, "dec", 01), the_fmt.to_sym
    end
  end
  
  def assert_format_eq(str, time_or_date, fmt, msg = 'Should format as desired')
    r = RuTils::DateTime::ru_strftime(time_or_date, fmt)
    assert_not_nil r, "The formatter should have returned a not-nil value for #{time_or_date} and #{fmt}"
    assert_kind_of String, "The formatter should have returned a String for #{time_or_date} and #{fmt}"
    assert_equal str, r, msg
  end
end

class StrftimeTest < Test::Unit::TestCase
  def test_strftime_bypassed_with_no_overrides
    with_overrides_set_to(false) do
      assert_equal "Sat, Saturday, Dec, December", Time.local(2005,"dec",31).strftime("%a, %A, %b, %B")
      assert_equal "%a, %A, %b, %B", Time.local(2005,"dec",31).strftime("%%a, %%A, %%b, %%B")
      assert_equal "%Sat, %Saturday, %Dec, %December", Time.local(2005,"dec",31).strftime("%%%a, %%%A, %%%b, %%%B")
      assert_equal "Сегодня: 31 December, Saturday, 2005 год", Time.local(2005,"dec",31).strftime("Сегодня: %d %B, %A, %Y год")
      assert_equal "01 December", Time.local(1985, "dec", 01).strftime("%d %B")
      assert_equal "11 December", Time.local(1985, "dec", 11).strftime("%d %B")
    end
  end
  
  def test_strftime_used_with_overrides
    with_overrides_set_to(true) do
      assert_equal "Сегодня: 31 декабря, суббота, 2005 год", 
        Time.local(2005,"dec",31).strftime("Сегодня: %d %B, %A, %Y год")
    end
  end
  
  def test_overrides_should_be_thread_safe
    a = Thread.new do
      120.times do
        RuTils::overrides = true
        sleep(rand(10)/200.0)
        assert_equal "11 декабря", Time.local(1985, "dec", 11).strftime("%d %B")
      end
    end
    
    b = Thread.new do
      120.times do
        RuTils::overrides = false
        sleep(rand(10)/200.0)
        assert_equal "11 December", Time.local(1985, "dec", 11).strftime("%d %B")
      end
    end
    
    ensure
     a.join; b.join 
  end
  
  def with_overrides_set_to(value, &blk)
    begin
      RuTils::overrides, s = value, RuTils::overrides_enabled?
      yield
    ensure; 
      RuTils::overrides = s
    end
  end
end


