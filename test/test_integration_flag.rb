# -*- encoding: utf-8 -*- 
$KCODE = 'u' if RUBY_VERSION < '1.9.0'
require 'test/unit'

require File.dirname(__FILE__) + '/../lib/rutils'

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