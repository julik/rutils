# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rutils}
  s.version = "0.2.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Julian 'Julik' Tarkhanov", "Danil Ivanov", "Yaroslav Markin"]
  s.date = %q{2009-01-18}
  s.description = %q{Simple processing of russian strings}
  s.email = ["me@julik.nl", "yaroslav@markin.net"]
  s.executables = ["gilensize", "rutilize"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt", "TODO.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile.rb", "TODO.txt", "bin/gilensize", "bin/rutilize", "init.rb", "lib/countries/countries.rb", "lib/datetime/datetime.rb", "lib/gilenson/gilenson.rb", "lib/integration/blue_cloth_override.rb", "lib/integration/integration.rb", "lib/integration/rails_date_helper_override.rb", "lib/integration/rails_pre_filter.rb", "lib/integration/red_cloth_four.rb", "lib/integration/red_cloth_override.rb", "lib/integration/red_cloth_three.rb", "lib/pluralizer/pluralizer.rb", "lib/rutils.rb", "lib/version.rb", "lib/transliteration/bidi.rb", "lib/transliteration/simple.rb", "lib/transliteration/transliteration.rb", "test/run_tests.rb", "test/t_datetime.rb", "test/t_gilenson.rb", "test/t_integration.rb", "test/t_pluralize.rb", "test/t_rutils_base.rb", "test/t_transliteration.rb", "test/test_integration_bluecloth.rb", "test/test_integration_redcloth3.rb", "test/test_integration_redcloth4.rb", "test/test_rails_filter.rb", "test/test_rails_helpers.rb", "test/test_datetime.rb", "test/test_gilenson.rb", "test/test_integration.rb", "test/test_pluralize.rb", "test/test_rutils_base.rb", "test/test_transliteration.rb"]
  s.has_rdoc = true
  s.homepage = %q{RuTils - простой обработчик русского текста на Ruby. Основная цель RuTils -}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rutils}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Simple processing of russian strings}
  s.test_files = ["test/test_datetime.rb", "test/test_gilenson.rb", "test/test_integration.rb", "test/test_integration_bluecloth.rb", "test/test_integration_redcloth3.rb", "test/test_integration_redcloth4.rb", "test/test_pluralize.rb", "test/test_rails_filter.rb", "test/test_rails_helpers.rb", "test/test_rutils_base.rb", "test/test_transliteration.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
