require 'sly'
require 'fileutils'

include FileUtils

load "sprintly_details.rb"

RSpec.configure do |config|

  config.before(:suite) do
    @real_home = ENV['HOME']
    fake_home = File.join('/tmp', 'fakehome')
    rm_rf fake_home if File.exists? fake_home
    mkdir_p fake_home
    ENV['HOME'] = fake_home
  end

  config.after(:suite) do
    ENV['HOME'] = @real_home
  end

end
