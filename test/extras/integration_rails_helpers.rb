# -*- encoding: utf-8 -*- 

require "ostruct"
require 'action_controller'
require 'action_view'
require 'action_controller/test_process'
require File.dirname(__FILE__) +  '/../../init.rb'
require 'action_pack/version'

ma, mi, ti = ActionPack::VERSION::MAJOR, ActionPack::VERSION::MINOR, ActionPack::VERSION::TINY 

raise LoadError, "RuTils is not 2.2.2 compat" if (ma >= 2 && mi >= 2 && ti >= 1)


ActionController::Routing::Routes.draw {  |map| map.connect ':controller/:action/:id' }
rails_test_class = defined?(ActionController::TestCase) ? ActionController::TestCase : Test::Unit::TestCase

# Перегрузка helper'ов Rails
class RailsDateHelperTest < Test::Unit::TestCase
  TEST_DATE = Date.parse("1983-10-15") # coincidentially...
  TEST_TIME = Time.local(1983, 10, 15, 12, 15) # also coincidentially...
  
  # Вспомогательный класс для тестирования перегруженного DateHelper
  class HelperStub
    # для тестирования to_datetime_select_tag
    def date_field; TEST_TIME; end
  end

  def setup
    RuTils::overrides = true
    # А никто и не говорил что класс должен быть один :-)
    k = Class.new(HelperStub)
    [ActionView::Helpers::TagHelper, ActionView::Helpers::DateHelper, RuTils::DateHelper].each{|m| k.send(:include, m)}
    @stub = k.new
  end
  
  def test_distance_of_time_in_words
    RuTils::overrides = true
    assert_equal "20 минут", @stub.distance_of_time_in_words(Time.now - 20.minutes, Time.now)
  end
  
  def test_select_month
    RuTils::overrides = true
    
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
  end

  def test_select_date  
    assert_match /date\_day.+date\_month.+date\_year/m, @stub.select_date(TEST_DATE),
      "Хелпер select_date должен выводить поля в следующем порядке: день, месяц, год"
    assert_match /декабря/, @stub.select_date(TEST_DATE), 
      "Имя месяца должно быть указано в родительном падеже"
    assert_match /декабря/, @stub.select_date(TEST_DATE, :order => [:month, :year]),
      "Хелпер select_date не позволяет опускать фрагменты, имя месяца должно быть указано в родительном падеже"
    assert_match @stub.select_date, @stub.select_date(Time.now), 
      "Хелпер select_date без параметров работает с текущей датой"
  end

  def test_select_datetime
    assert_match /date\_day.+date\_month.+date\_year/m, @stub.select_datetime(TEST_TIME),
      "Хелпер select_datetime должен выводить поля в следующем порядке: день, месяц, год"
  end
  
  def test_html_options
    if defined?(ActionView::Helpers::DateHelper::DATE_HELPERS_RECEIVE_HTML_OPTIONS)
      assert_match /id\=\"foobar\"/m,  @stub.select_month(TEST_DATE, {}, :id => "foobar"),
        "Хелпер select_month принимает html_options"

      assert_match /id\=\"foobar\"/m,  @stub.select_date(TEST_DATE, {}, :id => "foobar"),
        "Хелпер select_date принимает html_options"
    end
  end
end

class DateHelperWithControllerTest < rails_test_class
  TEST_DATE = Date.parse("1983-10-15") # coincidentially...
  
  class DatifiedController < ActionController::Base #:nodoc:
    def schmoo
      @widget = OpenStruct.new(:birthday => TEST_DATE)
      render :inline => '<%= date_select(:widget, :birthday) %>'
    end
    def rescue_action(e); raise e; end
  end
  
  if respond_to?(:tests) # Еще одно изобретение чтобы как можно больше вещей были несовместимы от рельсов к рельсам 
    tests DatifiedController
  end
  
  def setup
    @controller = DatifiedController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end 

  def test_select_month
    RuTils::overrides = true
    
    get :schmoo
    assert_match /июля/, @response.body
  end
end