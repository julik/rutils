# -*- encoding: utf-8 -*- 
$KCODE = 'u'
require 'test/unit'

require File.dirname(__FILE__) + '/../lib/rutils'

# Load all the prereqs
integration_tests = ['rubygems', 'multi_rails_init'] + Dir.glob(File.dirname(__FILE__) + '/extras/integration_*.rb')

# Specifically for Ruby 1.9.1 (too early at this point)
if ENV['NO_RAILS'] || RUBY_VERSION =~ /^1\.9/
  STDERR.puts "Skipping Rails tests - NO_RAILS set in ENV or running on Ruby 1.9+"
  integration_tests.reject! {|t| t.include?("rails") }
end

integration_tests.each do | integration_test |
  begin
    require integration_test
  rescue LoadError => e
    STDERR.puts "Skipping integration test #{File.basename(integration_test)} - deps not met (#{e.message})"
  end
end