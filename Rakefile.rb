require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'
require 'lib/rutils'

begin
  require 'xforge'
rescue LoadError
end

PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_NAME      = 'rutils'
PKG_VERSION   = RuTils::VERSION
PKG_FILE_NAME   = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_DESTINATION = "../#{PKG_NAME}"
PKG_SUMMARY	= %q{ Simple processing of russian strings }
PKG_DESCRIPTION = %q{ Allows simple processing of russian strings - transliteration, numerals as text and HTML beautification }
PKG_HOMEPAGE = 'http://rubyforge.org/projects/rutils'
PKG_EMAIL = 'me@julik.nl'
PKG_MAINTAINER = 'Julian "Julik" Tarkhanov'

RELEASE_NAME  = "rutils-#{PKG_VERSION}"

RUBY_FORGE_PROJECT = "rutils"
RUBY_FORGE_USER    = ENV['RUBY_FORGE_USER'] ? ENV['RUBY_FORGE_USER'] : "julik"

# нам нужна документация в Юникоде. А вы думали?
PKG_RDOC_OPTS = ['--main=README',
                 '--line-numbers',
                 '--webcvs=http://rubyforge.org/cgi-bin/viewcvs.cgi/rutils/%s?cvsroot=rutils',
                 '--charset=utf-8',
                 '--promiscuous']

task :default => [ :test ]

desc "Run all tests (requires BlueCloth, RedCloth and Rails for integration tests)"
Rake::TestTask.new("test") { |t|
  t.libs << "test"
  t.pattern = 'test/t_*.rb'
  t.verbose = true
}

desc "Report KLOCs"
task :stats  do
  require 'code_statistics'
  CodeStatistics.new(
    ["Libraries", "lib"], 
    ["Units", "test"]
  ).to_s
end

desc "Generate RDoc documentation"
Rake::RDocTask.new("doc") do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title  = PKG_SUMMARY
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('TODO')
  rdoc.options = PKG_RDOC_OPTS
  rdoc.rdoc_files.include FileList['lib/*.rb', 'lib/**/*.rb']
end

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = PKG_NAME
  s.summary = PKG_SUMMARY
  s.description = PKG_DESCRIPTION
  s.version = PKG_VERSION

  s.author = PKG_MAINTAINER
  s.email = PKG_EMAIL
  s.rubyforge_project = RUBY_FORGE_PROJECT
  s.homepage = PKG_HOMEPAGE

  s.has_rdoc = true
  s.files  = FileList["{bin,test,lib}/**/*"].exclude("rdoc").exclude(".svn").exclude(".CVS").exclude(".DS_Store").to_a +
	  %w(CHANGELOG init.rb Rakefile.rb README TODO)
	s.require_path = "lib"
	s.autorequire = "rutils"
	s.test_file = "test/run_tests.rb"
	s.has_rdoc = true
	s.extra_rdoc_files = ["README", "TODO", "CHANGELOG"]
	s.rdoc_options = PKG_RDOC_OPTS
	s.executables << 'gilensize'
	s.executables << 'rutilize'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end


desc "Remove packaging products (doc and pkg) - they are not source-managed"
task :clobber do
	`rm -rf ./doc`
	`rm -rf ./pkg`
end

desc "Publish the new docs"
task :publish_docs => [:clobber, :doc] do
  push_docs
end

desc "Push docs to servers"
task :push_docs do
  user = "#{ENV['USER']}@rubyforge.org" 
  project = '/var/www/gforge-projects/rutils'
  local_dir = 'doc'
  [ 
    Rake::SshDirPublisher.new( user, project, local_dir),
    Rake::SshDirPublisher.new('julik', '~/www/code/rutils', local_dir),
  
  ].each { |p| p.upload }
end


desc "Publish the release files to RubyForge."
task :release => [:clobber, :package] do
    cvs_aware_revision = 'r_' + PKG_VERSION.gsub(/-|\./, '_')
    `cvs tag #{cvs_aware_revision} .`
end