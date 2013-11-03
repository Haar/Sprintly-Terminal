module Sly
  VERSION = '0.2.3'

  class VersionChecker
    def self.run
      minimum_version = Gem::Version.new('1.9.2')
      current_version = Gem::Version.new(RUBY_VERSION)
      raise 'Ruby versions less than 1.9.2 are not supported by Sly' if minimum_version > current_version
    end
  end
end
