# frozen_string_literal: true
$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'notion/version'

Gem::Specification.new do |s|
  s.name = 'notion-ruby-client'
  s.version = Notion::VERSION
  s.authors = ['Nicolas Goutay']
  s.email = 'nicolas.goutay@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 1.3.6'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/phacks/notion-ruby-client'
  s.licenses = ['MIT']
  s.summary = 'Notion API client for Ruby.'
  s.add_dependency 'faraday', '>= 2.0'
  s.add_dependency 'faraday-mashify', '>= 0.1.1'
  s.add_dependency 'faraday-multipart', '>= 1.0.4'
  s.add_dependency 'hashie', '~> 5'
  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop', '~> 0.82.0'
  s.add_development_dependency 'rubocop-performance', '~> 1.5.2'
  s.add_development_dependency 'rubocop-rspec', '~> 1.39.0'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
end
