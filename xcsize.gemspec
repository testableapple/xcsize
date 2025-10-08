# frozen_string_literal: true

require_relative 'lib/xcsize/version'

Gem::Specification.new do |spec|
  spec.name = 'xcsize'
  spec.version = Xcsize::VERSION
  spec.authors = ['Alexey Alter-Pesotskiy']
  spec.email = ['alex@testableapple.com']

  spec.summary = 'Measure iOS and macOS app and framework sizes using linkmaps'
  spec.description = 'A Ruby gem to profile iOS and macOS app and framework sizes from linkmap files, providing detailed breakdowns and insights.'
  spec.homepage = 'https://github.com/testableapple/xcsize'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.bindir = 'bin'
  spec.executables = ['xcsize']
  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4'

  spec.add_dependency('commander', '>= 4.6', '< 6.0')

  spec.metadata['rubygems_mfa_required'] = 'true'
end
