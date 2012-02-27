# -*- encoding: utf-8 -*-
require File.expand_path('../lib/time_range', __FILE__)

Gem::Specification.new do |s|
  s.add_development_dependency('rake', '>= 0.8')
  s.add_development_dependency('rspec', '>= 2.5')
  s.add_dependency('i18n')
  s.add_dependency('active_support')
  #s.add_development_dependency('yard')
  s.authors = ["Alessandro Morandi", "Riccardo Cambiassi"]
  s.description = %q{A class for working with Time ranges}
  s.email = ['alessandro.morandi@dachisgroup.com', 'riccardo.cambiassi@dachisgroup.com']
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/headshift/time_range'
  s.name = 'time_range'
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.rubyforge_project = s.name
  s.summary = %q{Class to deal with Time ranges}
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = TimeRange::VERSION.dup
end
