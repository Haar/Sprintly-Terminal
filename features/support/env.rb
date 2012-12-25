require 'aruba/cucumber'
require 'fileutils'

include FileUtils

load 'sprintly_details.rb'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  @aruba_timeout_seconds = 5
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  @real_home = ENV['HOME']
  fake_home = File.join('/tmp', 'fakehome')
  rm_rf fake_home if File.exists? fake_home
  mkdir_p fake_home
  ENV['HOME'] = fake_home
end

After do
  rm_rf @dirs
  ENV['RUBYLIB'] = @original_rubylib
  ENV['HOME'] = @real_home
  # Scrap everything ready to start again next time
  rm_rf "/tmp"
end
