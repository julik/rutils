# -*- encoding: utf-8 -*- 
$KCODE = 'u'
$:.reject! { |e| e.include? 'TextMate' }

require 'lib/version'

begin
  require 'rubygems'
  require 'hoe'
  
  DOCOPTS = %w(--charset utf-8 --promiscuous)
  
  # Disable spurious warnings when running tests, ActiveMagic cannot stand -w
  Hoe::RUBY_FLAGS.replace ENV['RUBY_FLAGS'] || "-I#{%w(lib test).join(File::PATH_SEPARATOR)}" + 
    (Hoe::RUBY_DEBUG ? " #{RUBY_DEBUG}" : '')
  
  #Rake::RDocTask.class_eval do
  #  alias_method :_odefine, :define
  #  def define; @options.unshift(*DOCOPTS); _odefine; end
  #end

  rutils = Hoe.spec('rutils') do |p|
    p.version = RuTils::VERSION
    p.name = "rutils"
    p.author = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
    p.email = ['me@julik.nl', 'yaroslav@markin.net']
    p.description = 'Simple processing of russian strings'
    p.summary     = 'Simple processing of russian strings'
    p.extra_deps = {"gilenson" => ">=1.1.0"}
    p.remote_rdoc_dir = ''
    p.need_zip = true # ненвижу
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