$KCODE = 'u'
require 'test/unit'
require 'rubygems'

begin
  require 'action_controller' unless defined?(ActionController)
  require 'action_view' unless defined?(ActionView)
rescue LoadError
  $skip_rails = true
end

begin
  require 'RedCloth' unless defined?(RedCloth)
rescue LoadError
  $skip_redcloth = true
end

begin
  require 'BlueCloth' unless defined?(BlueCloth)
rescue LoadError
  $skip_bluecloth = true
end

require File.dirname(__FILE__) + '/../lib/rutils'
load File.dirname(__FILE__) +  '/../lib/integration/integration.rb'

class IntegrationFlagTest < Test::Unit::TestCase
  def setup
    RuTils::overrides = true
  end
  
  def test_integration_flag
    RuTils::overrides = false
    assert !RuTils::overrides_enabled?
    RuTils::overrides = true    
    assert RuTils::overrides_enabled?
  end  
end

# Интеграция с RedCloth - Textile.
# Нужно иметь в виду что Textile осуществляет свою обработку типографики, которую мы подменяем!
class TextileIntegrationTest < Test::Unit::TestCase
  def test_integration_textile
    raise "You must have RedCloth to test Textile integration" and return if $skip_redcloth

    RuTils::overrides = true
    assert RuTils.overrides_enabled?
    assert_equal "<p>И&#160;вот &#171;они пошли туда&#187;, и&#160;шли шли&#160;шли</p>", 
      RedCloth.new('И вот "они пошли туда", и шли шли шли').to_html

    RuTils::overrides = false      
    assert !RuTils::overrides_enabled?
    assert_equal '<p><strong>strong text</strong> and <em>emphasized text</em></p>',
      RedCloth.new("*strong text* and _emphasized text_").to_html, "Spaces should be preserved \
without RuTils"
    
    RuTils::overrides = true      
    assert RuTils.overrides_enabled?
    assert_equal '<p><strong>strong text</strong> and <em>emphasized text</em></p>',
      RedCloth.new("*strong text* and _emphasized text_").to_html, "Spaces should be preserved"
    
    RuTils::overrides = false
    assert !RuTils.overrides_enabled?
    assert_equal "<p>И вот &#8220;они пошли туда&#8221;, и шли шли шли</p>", 
      RedCloth.new('И вот "они пошли туда", и шли шли шли').to_html
  
  end
end

# Интеграция с BlueCloth - Markdown
# Сам Markdown никакой обработки типографики не производит (это делает RubyPants, но вряд ли его кто-то юзает на практике)
class MarkdownIntegrationTest < Test::Unit::TestCase
  def test_integration_markdown
    raise "You must have BlueCloth to test Markdown integration" and return if $skip_bluecloth

    RuTils::overrides = true
    assert RuTils.overrides_enabled?
    assert_equal "<p>И вот&#160;&#171;они пошли туда&#187;, и&#160;шли шли&#160;шли</p>", 
      BlueCloth.new('И вот "они пошли туда", и шли шли шли').to_html

    RuTils::overrides = false
    assert !RuTils.overrides_enabled?
    assert_equal "<p>И вот \"они пошли туда\", и шли шли шли</p>", 
      BlueCloth.new('И вот "они пошли туда", и шли шли шли').to_html
  end
end

TEST_DATE = Date.parse("1983-10-15") # coincidentially...
TEST_TIME = Time.local(1983, 10, 15, 12, 15) # also coincidentially...

class HelperTester
  def get_distance
    distance_of_time_in_words(Time.now - 20.minutes, Time.now)
  end
  
  def get_select_month
    select_month(TEST_DATE)
  end

  def get_select_month_use_month_numbers
    select_month(TEST_DATE, :use_month_numbers => true)
  end

  def get_select_month_add_month_numbers
    select_month(TEST_DATE, :add_month_numbers => true)
  end

  def get_select_month_use_short_month
    select_month(TEST_DATE, :use_short_month => true)
  end
  
  def get_date_select
    select_date(TEST_DATE)
  end
  
  def get_date_select_no_options
    select_date
  end

  def get_date_select_today
    select_date(Date.today)
  end

  def get_date_select_without_day
    select_date(TEST_DATE, :order => [:month, :year])
  end
  
  def get_datetime
    select_datetime(TEST_TIME)
  end
  
  def get_datetime_no_options
    select_datetime
  end
  
  def get_datetime_now
    select_datetime(Time.now)
  end
  
  def get_datetime_with_options
    select_datetime(TEST_TIME, :add_month_numbers => true)
  end
end

# Перегрузка helper'ов Rails
# TODO добавить и обновить тесты из Rails
class RailsHelpersOverrideTest < Test::Unit::TestCase
  def setup
    raise "You must have Rails to test ActionView integration" and return if $skip_rails
    RuTils::overrides = true
    
    HelperTester.class_eval { include ActionView::Helpers::DateHelper }
    @stub = HelperTester.new
  end
  
  def test_distance_of_time_in_words
    assert_equal "20 минут", @stub.distance_of_time_in_words(Time.now - 20.minutes, Time.now)
    # TODO more tests in t_datetime, just wrapper here
  end
  
  def test_select_month
    expected_select_month = "<select id=\"date_month\" name=\"date[month]\">\n<option value=\"1\">январь</option>\n<option value=\"2\">февраль</option>\n<option value=\"3\">март</option>\n<option value=\"4\">апрель</option>\n<option value=\"5\">май</option>\n<option value=\"6\">июнь</option>\n<option value=\"7\">июль</option>\n<option value=\"8\">август</option>\n<option value=\"9\">сентябрь</option>\n<option value=\"10\" selected=\"selected\">октябрь</option>\n<option value=\"11\">ноябрь</option>\n<option value=\"12\">декабрь</option>\n</select>\n"
    assert_equal expected_select_month, @stub.get_select_month, "Хелпер select_month без опций"

    assert_match /июль/, @stub.get_select_month, "Месяц в выборе месяца должен быть указан в именительном падеже"
    
    expected_select_month_umn = "<select id=\"date_month\" name=\"date[month]\">\n<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option value=\"3\">3</option>\n<option value=\"4\">4</option>\n<option value=\"5\">5</option>\n<option value=\"6\">6</option>\n<option value=\"7\">7</option>\n<option value=\"8\">8</option>\n<option value=\"9\">9</option>\n<option value=\"10\" selected=\"selected\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n</select>\n"
    assert_equal expected_select_month_umn, @stub.get_select_month_use_month_numbers, "Хелпер select_month с номером месяца вместо названия месяца"
    
    expected_select_month_amn = "<select id=\"date_month\" name=\"date[month]\">\n<option value=\"1\">1 - январь</option>\n<option value=\"2\">2 - февраль</option>\n<option value=\"3\">3 - март</option>\n<option value=\"4\">4 - апрель</option>\n<option value=\"5\">5 - май</option>\n<option value=\"6\">6 - июнь</option>\n<option value=\"7\">7 - июль</option>\n<option value=\"8\">8 - август</option>\n<option value=\"9\">9 - сентябрь</option>\n<option value=\"10\" selected=\"selected\">10 - октябрь</option>\n<option value=\"11\">11 - ноябрь</option>\n<option value=\"12\">12 - декабрь</option>\n</select>\n"
    assert_equal expected_select_month_amn, @stub.get_select_month_add_month_numbers, "Хелпер select_month с номером и названием месяца"
    
    expected_select_month_usm = "<select id=\"date_month\" name=\"date[month]\">\n<option value=\"1\">янв</option>\n<option value=\"2\">фев</option>\n<option value=\"3\">мар</option>\n<option value=\"4\">апр</option>\n<option value=\"5\">май</option>\n<option value=\"6\">июн</option>\n<option value=\"7\">июл</option>\n<option value=\"8\">авг</option>\n<option value=\"9\">сен</option>\n<option value=\"10\" selected=\"selected\">окт</option>\n<option value=\"11\">ноя</option>\n<option value=\"12\">дек</option>\n</select>\n"
    assert_equal expected_select_month_usm, @stub.get_select_month_use_short_month, "Хелпер select_month с использованием короткого имени месяца"
    
    # TODO HTML OPTIONS
  end

  def test_select_date  
    expected_date_select = "<select id=\"date_day\" name=\"date[day]\">\n<option value=\"1\">1</option>\n<option value=\"2\">2</option>\n<option value=\"3\">3</option>\n<option value=\"4\">4</option>\n<option value=\"5\">5</option>\n<option value=\"6\">6</option>\n<option value=\"7\">7</option>\n<option value=\"8\">8</option>\n<option value=\"9\">9</option>\n<option value=\"10\">10</option>\n<option value=\"11\">11</option>\n<option value=\"12\">12</option>\n<option value=\"13\">13</option>\n<option value=\"14\">14</option>\n<option value=\"15\" selected=\"selected\">15</option>\n<option value=\"16\">16</option>\n<option value=\"17\">17</option>\n<option value=\"18\">18</option>\n<option value=\"19\">19</option>\n<option value=\"20\">20</option>\n<option value=\"21\">21</option>\n<option value=\"22\">22</option>\n<option value=\"23\">23</option>\n<option value=\"24\">24</option>\n<option value=\"25\">25</option>\n<option value=\"26\">26</option>\n<option value=\"27\">27</option>\n<option value=\"28\">28</option>\n<option value=\"29\">29</option>\n<option value=\"30\">30</option>\n<option value=\"31\">31</option>\n</select>\n<select id=\"date_month\" name=\"date[month]\">\n<option value=\"1\">января</option>\n<option value=\"2\">февраля</option>\n<option value=\"3\">марта</option>\n<option value=\"4\">апреля</option>\n<option value=\"5\">мая</option>\n<option value=\"6\">июня</option>\n<option value=\"7\">июля</option>\n<option value=\"8\">августа</option>\n<option value=\"9\">сентября</option>\n<option value=\"10\" selected=\"selected\">октября</option>\n<option value=\"11\">ноября</option>\n<option value=\"12\">декабря</option>\n</select>\n<select id=\"date_year\" name=\"date[year]\">\n<option value=\"1978\">1978</option>\n<option value=\"1979\">1979</option>\n<option value=\"1980\">1980</option>\n<option value=\"1981\">1981</option>\n<option value=\"1982\">1982</option>\n<option value=\"1983\" selected=\"selected\">1983</option>\n<option value=\"1984\">1984</option>\n<option value=\"1985\">1985</option>\n<option value=\"1986\">1986</option>\n<option value=\"1987\">1987</option>\n<option value=\"1988\">1988</option>\n</select>\n"
    
    assert_equal expected_date_select, @stub.get_date_select, "Хелпер date_select без опций"
    assert_match /декабря/, @stub.get_date_select, "Имя месяца должно быть указано в родительном падеже"

    assert_match /декабря/, @stub.get_date_select_without_day,
      "Хелпер select_date не позволяет опускать фрагменты, имя месяца должно быть указано в родительном падеже"

    assert_match @stub.get_date_select_no_options, @stub.get_date_select_today, "Хелпер select_date без параметров работает с текущей датой"
    # TODO HTML options
  end

  def test_select_datetime
    assert_match /date\_day.+date\_month.+date\_year.+date\_hour.+date\_minute/m, @stub.get_datetime, "Хелпер select_datetime должен выводить поля в следующем порядке: день, месяц, год, час, минута"
    
    assert_match /10\ \-\ октябрь/, @stub.get_datetime_with_options, "Хелпер select_datetime должен передавать опции вспомогательным хелперам"

    assert_match @stub.get_datetime_no_options, @stub.get_datetime_now, "Хелпер select_datetime без параметров работает с текущей датой"

    # TODO HTML options
  end
end

