require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'fileutils'

PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_NAME      = 'rutils'
PKG_VERSION   = '0.01' + PKG_BUILD + Time.now.to_i.to_s
PKG_FILE_NAME   = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_DESTINATION = ENV["RAILS_PKG_DESTINATION"] || "../#{PKG_NAME}"
PKG_SUMMARY	= %q{ Simple processing of russian strings }
PKG_DESCRIPTION = %q{ Allows simple processing of russian strings - transliteration, numerals as text and HTML beautification }
PKG_HOMEPAGE = 'http://rubyforge.org/projects/rutils'
PKG_EMAIL = 'me@julik.nl'
PKG_MAINTAINER = 'Julian "Julik" Tarkhanov'

RELEASE_NAME  = "REL #{PKG_VERSION}"

RUBY_FORGE_PROJECT = "rutils"
RUBY_FORGE_USER    = "julik"

# нам нужна документация в Юникоде. А вы думали?
PKG_RDOC_OPTS = '--charset UTF-8 --main README --line-numbers'

desc "Run all tests (requires BlueCloth, RedCloth and Rails for integration tests)"
task :default => [ :test ]

desc "Run tests"
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
  rdoc.options << PKG_RDOC_OPTS
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('CHANGELOG')
  rdoc.rdoc_files.include('TODO')
  rdoc.rdoc_files.include FileList['lib/*.rb', 'lib/**/*.rb']
end

desc "Create compressed pkgs"
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
	s.files = FileList["{bin,test,lib}/**/*"].exclude("rdoc").exclude(".svn").exclude(".CVS").to_a + ["Rakefile.rb"]
	s.require_path = "lib"
	s.autorequire = "rutils"
	s.test_file = "test/run_tests.rb"
	s.has_rdoc = "true"
	s.extra_rdoc_files = ["README", "TODO", "CHANGELOG"]
	s.rdoc_options = PKG_RDOC_OPTS
	s.executables << 'gilensize'
end

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end


desc "Publish the beta gem to julik.nl"
task :betagem => [:test , :stats, :package] do 
  Rake::SshFilePublisher.new("julik@julik.nl", "public_html/gems", "pkg", "#{PKG_FILE_NAME}.gem").upload
end

desc "Publish the release files to RubyForge."
task :release => [:test, :package] do
  files = ["gem", "tgz", "zip"].map { |ext| "pkg/#{PKG_FILE_NAME}.#{ext}" }

  if RUBY_FORGE_PROJECT then
    require 'net/http'
    require 'open-uri'

    project_uri = "http://rubyforge.org/projects/#{RUBY_FORGE_PROJECT}/"
    project_data = open(project_uri) { |data| data.read }
    group_id = project_data[/[?&]group_id=(\d+)/, 1]
    raise "Couldn't get group id" unless group_id

    # This echos password to shell which is a bit sucky
    if ENV["RUBY_FORGE_PASSWORD"]
      password = ENV["RUBY_FORGE_PASSWORD"]
    else
      print "#{RUBY_FORGE_USER}@rubyforge.org's password: "
      password = STDIN.gets.chomp
    end

    login_response = Net::HTTP.start("rubyforge.org", 80) do |http|
      data = [
        "login=1",
        "form_loginname=#{RUBY_FORGE_USER}",
        "form_pw=#{password}"
      ].join("&")
      http.post("/account/login.php", data)
    end

    cookie = login_response["set-cookie"]
    raise "Login failed" unless cookie
    headers = { "Cookie" => cookie }

    release_uri = "http://rubyforge.org/frs/admin/?group_id=#{group_id}"
    release_data = open(release_uri, headers) { |data| data.read }
    package_id = release_data[/[?&]package_id=(\d+)/, 1]
    raise "Couldn't get package id" unless package_id

    first_file = true
    release_id = ""

    files.each do |filename|
      basename  = File.basename(filename)
      file_ext  = File.extname(filename)
      file_data = File.open(filename, "rb") { |file| file.read }

      puts "Releasing #{basename}..."

      release_response = Net::HTTP.start("rubyforge.org", 80) do |http|
        release_date = Time.now.strftime("%Y-%m-%d %H:%M")
        type_map = {
          ".zip"    => "3000",
          ".tgz"    => "3110",
          ".gz"     => "3110",
          ".gem"    => "1400"
        }; type_map.default = "9999"
        type = type_map[file_ext]
        boundary = "rubyqMY6QN9bp6e4kS21H4y0zxcvoor"

        query_hash = if first_file then
          {
            "group_id" => group_id,
            "package_id" => package_id,
            "release_name" => RELEASE_NAME,
            "release_date" => release_date,
            "type_id" => type,
            "processor_id" => "8000", # Any
            "release_notes" => "",
            "release_changes" => "",
            "preformatted" => "1",
            "submit" => "1"
          }
        else
          {
            "group_id" => group_id,
            "release_id" => release_id,
            "package_id" => package_id,
            "step2" => "1",
            "type_id" => type,
            "processor_id" => "8000", # Any
            "submit" => "Add This File"
          }
        end

        query = "?" + query_hash.map do |(name, value)|
          [name, URI.encode(value)].join("=")
        end.join("&")

        data = [
          "--" + boundary,
          "Content-Disposition: form-data; name=\"userfile\"; filename=\"#{basename}\"",
          "Content-Type: application/octet-stream",
          "Content-Transfer-Encoding: binary",
          "", file_data, ""
          ].join("\x0D\x0A")

        release_headers = headers.merge(
          "Content-Type" => "multipart/form-data; boundary=#{boundary}"
        )

        target = first_file ? "/frs/admin/qrs.php" : "/frs/admin/editrelease.php"
        http.post(target + query, data, release_headers)
      end

      if first_file then
        release_id = release_response.body[/release_id=(\d+)/, 1]
        raise("Couldn't get release id") unless release_id
      end

      first_file = false
    end
  end
end