# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'universal-access/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'universal-access'
  s.version     = UniversalAccess::VERSION
  s.authors     = ['Ben Petro']
  s.email       = ['ben@bthree.com.au']
  s.homepage    = ''
  s.summary     = 'Summary of UniversalAccess.'
  s.description = 'Description of UniversalAccess.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'haml'
  s.add_dependency 'mongoid'
  s.add_dependency 'rails', '>= 6.1.7.10', '< 7.1'
  s.metadata['rubygems_mfa_required'] = 'true'
end
