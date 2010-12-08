# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{time_freeze}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matthew Rudy Jacobs"]
  s.date = %q{2010-12-08}
  s.email = %q{MatthewRudyJacobs@gmail.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "test/test_helper.rb", "test/time_freeze_test.rb", "lib/time_freeze/time_extensions.rb", "lib/time_freeze.rb"]
  s.homepage = %q{http://yoursite.example.com}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{The simplest possible way to freeze time}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
