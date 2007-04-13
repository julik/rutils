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

TEST_DATE =  Date.parse("1983-10-15") # coincidentially...
TEST_TIME = Time.local(1983, 10, 15, 12, 15) # also coincidentially...
# Перегрузка helper'ов Rails
class RailsHelpersOverrideTest < Test::Unit::TestCase
  def test_distance_of_time_in_words
    raise "You must have Rails to test ActionView integration" and return if $skip_rails
    
    eval 'class HelperTester
            include ActionView::Helpers::DateHelper
            def get_distance
              distance_of_time_in_words(Time.now - 20.minutes, Time.now)
            end
            
            def get_select_month
              select_month(TEST_DATE)
            end
            
            def get_date_select
              select_date(TEST_DATE)
            end

            def get_date_select_without_day
              select_date(TEST_DATE, :order => [:month, :year])
            end

          end'
          
    RuTils::overrides = true
    stub = HelperTester.new
    assert_equal "20 минут", stub.get_distance
    assert_match /июль/, stub.get_select_month, "Месяц в выборе месяца должен быть указан в именительном падеже"
    assert_match /декабря/, stub.get_date_select, "Имя месяца должно быть указано в родительном падеже"
    assert_match /декабря/, stub.get_date_select_without_day,
      "Хелпер select_date не позволяет опускать фрагменты, имя месяца должно быть указано в родительном падеже"
    
  end
end

