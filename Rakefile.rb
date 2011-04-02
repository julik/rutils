# -*- encoding: utf-8 -*- 
$KCODE = 'u' if RUBY_VERSION < '1.9.0'
$:.reject! { |e| e.include? 'TextMate' }

require File.expand_path(File.dirname(__FILE__) + '/lib/version')

begin
  require 'rubygems'
  require 'hoe'
  
  DOCOPTS = %w(--charset utf-8 --promiscuous)
  
  # Disable spurious warnings when running tests, ActiveMagic cannot stand -w
  Hoe::RUBY_FLAGS.replace ENV['RUBY_FLAGS'] || "-I#{%w(lib test).join(File::PATH_SEPARATOR)}" + 
    (Hoe::RUBY_DEBUG ? " #{RUBY_DEBUG}" : '')
  
  rutils = Hoe.spec('rutils') do |p|
    p.version = RuTils::VERSION
    p.name = "rutils"
    p.author = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
    p.email = ['me@julik.nl', 'yaroslav@markin.net']
    p.description = 'DEPRECATED processing of russian strings'
    p.summary     = 'DEPRECATED processing of russian strings'
    p.extra_deps = {"gilenson" => ">=1.1.0", "russian" => ">= 0.2.7", "ru_propisju" => ">= 1.0.0"  }
  end
  
  rutils.spec.rdoc_options += DOCOPTS
  
  require 'load_multi_rails_rake_tasks'
  
rescue LoadError
  $stderr.puts "Meta-operations on this package require Hoe and multi_rails"
  task :default => [ :test ]
  
  require 'rake/testtask'
  desc "Run all tests (requires BlueCloth, RedCloth and Rails for integration tests)"
  Rake::TestTask.new("test") do |t|
    t.libs << "test"
    t.pattern = 'test/test_*.rb'
    t.verbose = true
  end
end
