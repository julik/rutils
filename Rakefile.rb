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
      def define; @main = 'README'; @options.unshift(*DOCOPTS); _odefine; end
    end
    
    def define_tasks
      extra_deps.reject! {|e| e[0] == 'hoe' }
      self.spec_extras.merge! :rdoc_options => (DOCOPTS.unshift "--main=README"), 
        # A bug in rubygems+rdoc, we have to point it to capitalized file names by hand 
        # see http://groups.google.com/group/ruby-core-google/browse_thread/thread/b022259469ebf3d1
        :extra_rdoc_files => ["README", "TODO", "CHANGELOG"]
      super
    end
  end
  
  KolkHoe.new('rutils', RuTils::VERSION) do |p|
    p.name = "rutils"
    p.author = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
    p.description = "A library for writing tests for your Camping app."
    p.email = 'me@julik.nl'
    p.summary = %q{ Simple processing of russian strings }
    
    changelog_pieces = File.read('CHANGELOG').split(/^Версия /)[0..1]
    # Если версия не указана берем кусок про trunk
    changelog_pieces.shift if changelog_pieces[0].strip.empty?
    
    p.changes = changelog_pieces[0].strip
    p.url = "http://rutils.rubyforge.org"
    p.rdoc_pattern = /#{p.rdoc_pattern}|README|CHANGELOG|TODO/
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