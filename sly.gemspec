# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','sly','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'Sly'
  s.version = Sly::VERSION
  s.author = 'Robert White'
  s.email = 'robert@terracoding.com'
  s.homepage = 'http://tallguyrob.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A small set of tools for working with Sprint.ly without leaving the command line.'
# Add your other files here if you make them
  s.files = Dir['bin/sly', 'lib/sly/version.rb', 'lib/sly.rb', 'lib/sly/*.rb']
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','sly.rdoc']
  s.rdoc_options << '--title' << 'sly' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'sly'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_dependency('curb', '>= 0.8')
  s.add_dependency('json', '>= 1.4')
  s.add_runtime_dependency('gli','>= 2.5.0')
end
