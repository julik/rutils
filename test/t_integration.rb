$KCODE = 'u'
require 'rubygems'
require 'test/unit'

def requiring_with_report(test = nil)
  begin
    yield
    require File.join(File.dirname(__FILE__), test) if test
  rescue LoadError => e
    $stderr.puts "Skipping integration test - #{e}"
  end
end

requiring_with_report { require 'multi_rails_init' }

requiring_with_report('test_rails_helpers') do
  require 'action_controller' unless defined?(ActionController)
  require 'action_view' unless defined?(ActionView)
end

requiring_with_report('test_integration_bluecloth') { require 'bluecloth' }
requiring_with_report do
  require 'RedCloth'
  if RedCloth::VERSION =~ /^3/
    require File.dirname(__FILE__) + '/test_integration_redcloth3'
  else
    require File.dirname(__FILE__) + '/test_integration_redcloth4'
  end
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