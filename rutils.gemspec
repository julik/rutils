# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rutils}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
  s.date = %q{2009-02-08}
  s.description = %q{Simple processing of russian strings}
  s.email = ["me@julik.nl", "yaroslav@markin.net"]
  s.executables = ["gilensize", "rutilize"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "TODO.txt", "WHAT_HAS_CHANGED.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile.rb", "TODO.txt", "WHAT_HAS_CHANGED.txt", "bin/gilensize", "bin/rutilize", "init.rb", "lib/countries/countries.rb", "lib/datetime/datetime.rb", "lib/gilenson/bluecloth_extra.rb", "lib/gilenson/gilenson.rb", "lib/gilenson/helper.rb", "lib/gilenson/maruku_extra.rb", "lib/gilenson/rdiscount_extra.rb", "lib/gilenson/redcloth_extra.rb", "lib/integration/integration.rb", "lib/integration/rails_date_helper_override.rb", "lib/integration/rails_pre_filter.rb", "lib/pluralizer/pluralizer.rb", "lib/rutils.rb", "lib/transliteration/bidi.rb", "lib/transliteration/simple.rb", "lib/transliteration/transliteration.rb", "lib/version.rb", "test/extras/integration_bluecloth.rb", "test/extras/integration_maruku.rb", "test/extras/integration_rails_filter.rb", "test/extras/integration_rails_gilenson_helpers.rb", "test/extras/integration_rails_helpers.rb", "test/extras/integration_rdiscount.rb", "test/extras/integration_redcloth3.rb", "test/extras/integration_redcloth4.rb", "test/run_tests.rb", "test/test_datetime.rb", "test/test_gilenson.rb", "test/test_integration.rb", "test/test_integration_flag.rb", "test/test_pluralize.rb", "test/test_rutils_base.rb", "test/test_transliteration.rb"]
  s.has_rdoc = true
  s.homepage = %q{RuTils - простой обработчик русского текста на Ruby. Основная цель RuTils -}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rutils}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple processing of russian strings}
  s.test_files = ["test/test_datetime.rb", "test/test_gilenson.rb", "test/test_integration.rb", "test/test_integration_flag.rb", "test/test_pluralize.rb", "test/test_rutils_base.rb", "test/test_transliteration.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
