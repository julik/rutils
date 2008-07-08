$KCODE = 'u'
require 'lib/rutils'

begin
  require 'rubygems'
  require 'hoe'

  # Disable spurious warnings when running tests, ActiveMagic cannot stand -w
  Hoe::RUBY_FLAGS.replace ENV['RUBY_FLAGS'] || "-I#{%w(lib test).join(File::PATH_SEPARATOR)}" + 
    (Hoe::RUBY_DEBUG ? " #{RUBY_DEBUG}" : '')
  
  # Hoe minus dependency pollution plus unidocs plus rdoc fix. Kommunizm, perestroika.
  class KolkHoe < Hoe
    DOCOPTS = %w(--webcvs=http://rutils.rubyforge.org/svn/trunk/%s --charset=utf-8 --promiscuous)
    Rake::RDocTask.class_eval do
      alias_method :_odefine, :define
      def define; @options.unshift(*DOCOPTS); _odefine; end
    end
    
    def define_tasks
      extra_deps.reject! {|e| e[0] == 'hoe' }
      self.spec_extras.merge! :rdoc_options => (DOCOPTS.unshift "--main=README.txt") 
      super
    end
  end
  
  KolkHoe.new('rutils', RuTils::VERSION) do |p|
    p.name = "rutils"
    p.author = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
    p.summary = %q{ Simple processing of russian strings }
    p.description = %q{ Allows simple processing of russian strings - transliteration, numerals as text and HTML beautification }
    p.email = 'me@julik.nl'
    p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
    p.url = "http://rutils.rubyforge.org"
    p.test_globs = 'test/t_*.rb'
    p.extra_deps = ['actionpack', 'activesupport']
  end
  
  require 'load_multi_rails_rake_tasks'
  
rescue LoadError
  $stderr.puts "Meta-operations on this package require Hoe and multi_rails"
  task :default => [ :test ]
  
  require 'rake/testtask'
  desc "Run all tests (requires BlueCloth, RedCloth and Rails for integration tests)"
  Rake::TestTask.new("test") do |t|
    t.libs << "test"
    t.pattern = 'test/t_*.rb'
    t.verbose = true
  end
end