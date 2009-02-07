# -*- encoding: utf-8 -*- 

require 'action_controller'
require 'action_view'

require 'action_controller/test_process'
require File.dirname(__FILE__) +  '/../../init.rb'

# Перегрузка helper'ов Rails
class RailsGilensonHelpersTest < Test::Unit::TestCase
  
  class Kontroller < ActionController::Base
    def action_with_gilensize
      render :inline => "<%= gilensize('Они пришли -- туда -- к А. П. Чехову') %>"
    end
    
    def action_with_gilensize_and_options
      render :inline => "<%= gilensize('Они пришли -- туда -- к А. П. Чехову', :raw_output => true) %>"
    end
    
    def action_with_textilize
      render :inline => "<%= textilize('Они пришли -- туда -- к А. П. Чехову') %>"
    end
    
    def action_with_textilize_without_overrides
      RuTils.overrides = false
      render :inline => "<%= textilize('Они пришли -- туда -- к А. П. Чехову') %>"
    end
    
    def action_with_markdown
      render :inline => "<%= markdown('Они пришли -- туда -- к А. П. Чехову') %>"
    end

    def action_with_markdown_without_overrides
      RuTils.overrides = false
      render :inline => "<%= markdown('Они пришли -- туда -- к А. П. Чехову') %>"
    end
    
    def rescue_action(e)
      raise e
    end
  end
  
  def setup
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    @controller = Kontroller.new
  end
  
  def test_action_with_gilensize
    get :action_with_gilensize
    assert_equal 'Они&#160;пришли &#8212; туда &#8212; к&#160;А.П.&#8201;Чехову', @response.body
  end
  
  def test_action_with_gilensize_and_options
    get :action_with_gilensize_and_options
    assert_equal "Они пришли — туда — к А.П. Чехову", @response.body
  end
  
  def test_action_with_textilize
    get :action_with_textilize
    assert_equal "<p>Они пришли &#8212; туда &#8212; к&#160;А.П.&#8201;Чехову</p>", @response.body
  end
  
  def test_action_with_textilize_without_overrides
    get :action_with_textilize_without_overrides
    assert_equal "<p>Они пришли &#8212; туда &#8212; к А. П. Чехову</p>", @response.body, "Initials should not be formatted"
  end
  
  def test_action_with_markdown
    get :action_with_markdown
    assert_equal "<p>Они пришли &#8212; туда &#8212; к&#160;А.П.&#8201;Чехову</p>", @response.body
  end
  
  def test_action_with_markdown_without_overrides
    get :action_with_markdown_without_overrides
    assert_equal "<p>Они пришли -- туда -- к А. П. Чехову</p>", @response.body
  end
  
end