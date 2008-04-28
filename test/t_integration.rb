$KCODE = 'u'
require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'

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

# Вспомогательный класс для тестирования перегруженного DateHelper
class HelperTester
  include ActionView::Helpers::TagHelper
end

# Вспомогательный класс для тестирования перегруженного DateHelper
#
# Пытается эмулировать DateHelper из Rails Edge (2.1+) за счет
# поддержки в хелперах параметра html_options
class HelperTesterHtmlOptions
  include ActionView::Helpers::TagHelper
  
  # Taken from Rails Edge (2.1)
  def select_second(datetime, options = {}, html_options = {})
    val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.sec) : ''
    if options[:use_hidden]
      options[:include_seconds] ? hidden_html(options[:field_name] || 'second', val, options) : ''
    else
      second_options = []
      0.upto(59) do |second|
        second_options << ((val == second) ?
          content_tag(:option, leading_zero_on_single_digits(second), :value => leading_zero_on_single_digits(second), :selected => "selected") :
          content_tag(:option, leading_zero_on_single_digits(second), :value => leading_zero_on_single_digits(second))
        )
        second_options << "\n"
      end
      select_html(options[:field_name] || 'second', second_options.join, options, html_options)
    end
  end
  
  private
  
  # Taken from Rails Edge (2.1)
  def select_html(type, html_options, options, select_tag_options = {})
    name_and_id_from_options(options, type)
    select_options = {:id => options[:id], :name => options[:name]}
    select_options.merge!(:disabled => 'disabled') if options[:disabled]
    select_options.merge!(select_tag_options) unless select_tag_options.empty?
    select_html = "\n"
    select_html << content_tag(:option, '', :value => '') + "\n" if options[:include_blank]
    select_html << html_options.to_s
    content_tag(:select, select_html, select_options) + "\n"
  end
end

# Перегрузка helper'ов Rails
# TODO добавить и обновить тесты из Rails
class RailsHelpersOverrideTest < Test::Unit::TestCase
  def setup
    raise "You must have Rails to test ActionView integration" and return if $skip_rails
    RuTils::overrides = true

    HelperTester.send :include, ActionView::Helpers::DateHelper
    @stub = HelperTester.new
  end
  
  def test_distance_of_time_in_words
    assert_equal "20 минут", @stub.distance_of_time_in_words(Time.now - 20.minutes, Time.now)
    # TODO add more tests in t_datetime, just a wrapper here
  end
  
  def test_select_month
    assert_match /июль/, @stub.select_month(TEST_DATE), 
      "Месяц в выборе месяца должен быть указан в именительном падеже"
    assert_match />7\<\/option\>/, @stub.select_month(TEST_DATE, :use_month_numbers => true), 
      "Хелпер select_month с номером месяца вместо названия месяца"
    assert_match /10\ \-\ октябрь/, @stub.select_month(TEST_DATE, :add_month_numbers => true), 
      "Хелпер select_month с номером и названием месяца"
    assert_match /\>июн\<\/option\>/, @stub.select_month(TEST_DATE, :use_short_month => true), 
      "Короткое имя месяца при использовании опции :use_short_month"
    assert_match /name\=\"date\[foobar\]\"/, @stub.select_month(TEST_DATE, :field_name => "foobar"), 
      "Хелпер select_month должен принимать опцию :field_name"
    assert_match /type\=\"hidden\".+value\=\"10\"/m, @stub.select_month(TEST_DATE, :use_hidden => true),
      "Хелпер select_month должен принимать опцию :use_hidden"
    assert_match /type\=\"hidden\".+name=\"date\[foobar\]\"/m, @stub.select_month(TEST_DATE, :use_hidden => true, :field_name => "foobar"),
      "Хелпер select_month должен принимать опцию :use_hidden одновременно с :field_name"
  end

  def test_select_date  
    assert_match /date\_day.+date\_month.+date\_year/m, @stub.select_date(TEST_TIME),
      "Хелпер select_date должен выводить поля в следующем порядке: день, месяц, год"
    assert_match /декабря/, @stub.select_date(TEST_DATE), 
      "Имя месяца должно быть указано в родительном падеже"
    assert_match /декабря/, @stub.select_date(TEST_DATE, :order => [:month, :year]),
      "Хелпер select_date не позволяет опускать фрагменты, имя месяца должно быть указано в родительном падеже"
    assert_match @stub.select_date, @stub.select_date(Time.now), 
      "Хелпер select_date без параметров работает с текущей датой"
  end

  def test_select_datetime
    assert_match /date\_day.+date\_month.+date\_year.+date\_hour.+date\_minute/m, @stub.select_datetime(TEST_TIME),
      "Хелпер select_datetime должен выводить поля в следующем порядке: день, месяц, год, час, минута"
    assert_match /10\ \-\ октября/, @stub.select_datetime(TEST_TIME, :add_month_numbers => true), 
      "Хелпер select_datetime должен передавать опции вспомогательным хелперам"
    assert_match @stub.select_datetime, @stub.select_datetime(Time.now), 
      "Хелпер select_datetime без параметров работает с текущей датой"
  end
  
  def test_html_options
    RuTils::overrides = true
    HelperTesterHtmlOptions.send :include, ActionView::Helpers::DateHelper
    @stub_h = HelperTesterHtmlOptions.new
    @mock = flexmock(@stub_h)
    
    # неважно что возвращают хелперы select_[day|year|time], нам нужно только проверить
    # передачу html_options
    @mock.should_receive(:select_day).and_return("")
    @mock.should_receive(:select_year).and_return("")
    @mock.should_receive(:select_time).and_return("")

    assert_match /id=\"foobar\"/, @stub_h.select_month(TEST_DATE, {}, {:id => "foobar"}),
      "Хелпер select_month должен поддерживать html опции на Rails Edge (2.1+)"
    assert_match /id=\"foobar\"/, @stub_h.select_date(TEST_DATE, {}, {:id => "foobar"}), 
      "Хелпер select_date должен поддерживать html опции на Rails Edge (2.1+)"
    assert_match /id=\"foobar\"/, @stub_h.select_datetime(TEST_TIME, {}, {:id => "foobar"}), 
      "Хелпер select_datetime должен поддерживать html опции на Rails Edge (2.1+)"
  end
end

