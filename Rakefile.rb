$KCODE = 'u'
$:.reject! { |e| e.include? 'TextMate' }

require 'lib/rutils'
require 'rubygems'



begin
  require 'hoe'
  
  # Disable spurious warnings when running tests, ActiveMagic cannot stand -w
  Hoe::RUBY_FLAGS.replace ENV['RUBY_FLAGS'] || "-I#{%w(lib test).join(File::PATH_SEPARATOR)}" + 
    (Hoe::RUBY_DEBUG ? " #{RUBY_DEBUG}" : '')
  
  # The generic URI syntax mandates that new URI schemes that provide for the
  # representation of character data in a URI must, in effect, represent characters from
  # the unreserved set without translation, and should convert all other characters to
  # bytes according to UTF-8, # and then percent-encode those values. This requirement was
  # introduced in January 2005 with the publication of RFC 3986. URI schemes # introduced
  # before this date are not affected.
  
  # Hoe minus dependency pollution plus unidocs plus rdoc fix. Kommunizm, perestroika.
  class KolkHoe < Hoe
    DOCOPTS = %w(--webcvs=http://rutils.rubyforge.org/svn/trunk/%s --charset=utf-8 --promiscuous)
    Rake::RDocTask.class_eval do
      alias_method :_odefine, :define
      def define; @options.unshift(*DOCOPTS); _odefine; end
    end
    
    def define_tasks
      extra_deps.reject! {|e| e[0] == 'hoe' }
      super
    end
  end
  
  KolkHoe.new('rutils', RuTils::VERSION) do |p|
    p.name = "rutils"
    p.author = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
    p.email = ['me@julik.nl', 'yaroslav@markin.net']
    p.description = 'Simple processing of russian strings'
    p.summary     = 'Simple processing of russian strings'
    p.url = "http://rutils.rubyforge.org"
    p.test_globs = 'test/t_*.rb'
    p.remote_rdoc_dir = ''
    p.need_zip = true
    p.remote_rdoc_dir = ''
  end
  
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

begin
  require 'load_multi_rails_rake_tasks'
rescue LoadError
  $stderr.puts "Proper testing of this package with Rails requires multi_rails"
end