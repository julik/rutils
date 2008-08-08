$KCODE = 'u'
require 'rubygems'
require 'test/unit'

def requiring_with_dependencies(*tests)
  begin
    yield
    tests.map {|t|  require File.join(File.dirname(__FILE__), t) }
  rescue LoadError => e
    $stderr.puts "Skipping integration test - #{e}"
  end
end

requiring_with_dependencies { require 'multi_rails_init' }

requiring_with_dependencies('test_rails_helpers', 'test_rails_filter') do
  require 'action_controller' unless defined?(ActionController)
  require 'action_view' unless defined?(ActionView)
end


requiring_with_dependencies('test_integration_bluecloth') { require 'bluecloth' }
requiring_with_dependencies do
  require 'RedCloth' unless defined? RedCloth
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