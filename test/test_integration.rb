# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'

require File.dirname(__FILE__) + '/../lib/rutils'
load File.dirname(__FILE__) +  '/../lib/integration/integration.rb'

integration_tests = Dir.glob(File.dirname(__FILE__) + '/extras/integration_*.rb') + ['multi_rails_init']

if ENV['NO_RAILS']
  integration_tests.reject! {|t| t.include?("rails") }
end

integration_tests.each do | integration_test |
  begin
    require integration_test
  rescue LoadError => e
    $stderr.puts "Skipping integration test #{integration_test} - deps not met"
  end
end