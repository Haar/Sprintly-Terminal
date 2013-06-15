require 'webmock/cucumber'
require 'aruba/cucumber'
require 'curb'
require 'fileutils'

include FileUtils

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

FAKE_PROJECTS = [{"archived"=>false, "name"=>"sprint.ly", "admin"=>true, "created_at"=>"2012-08-15T12 => 10:14+00:00", "id" => 1, "email"=>{"tests"=>"tests-1@items.sprint.ly", "tasks"=>"tasks-1@items.sprint.ly", "stories"=>"stories-1@items.sprint.ly", "defects"=>"defects-1@items.sprint.ly", "backlog"=>"backlog-1@items.sprint.ly"}}].to_json


FAKE_ITEMS = [{ "status" => "backlog", "product" => { "archived" => false, "id" => 1, "name" => "sprint.ly" }, "description" => "Require people to estimate the score of an item before they can start working on it.", "tags" => [ "scoring", "backlog" ], "number" => 188, "archived" => false, "title" => "Don't let un-scored items out of the backlog.", "created_by" => { "first_name" => "Joe", "last_name" => "Stump", "id" => 1, "email" => "joe@joestump.net" }, "score" => "M", "assigned_to" => { "first_name" => "Joe", "last_name" => "Stump", "id" => 1, "email" => "joe@joestump.net" }, "type" => "task" }, { "status" => "accepted", "product" => { "archived" => false, "id" => 1, "name" => "sprint.ly" }, "description" => "", "tags" => [ "scoring", "backlog" ], "number" => 208, "archived" => false, "title" => "Add the ability to reply to comments via email.", "created_by" => { "first_name" => "Joe", "last_name" => "Stump", "id" => 1, "email" => "joe@joestump.net" }, "score" => "M", "assigned_to" => { "first_name" => "Joe", "last_name" => "Stump", "id" => 1, "email" => "joe@joestump.net" }, "type" => "task" }].to_json

Before do
  @aruba_timeout_seconds = 5
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  @real_home = ENV['HOME']
  fake_home = File.join('/tmp', 'fakehome')
  rm_rf fake_home if File.exists? fake_home
  mkdir_p fake_home
  ENV['HOME'] = fake_home
  stub_request(:any, "https://foo:bar@sprint.ly/api/products/1/items.json").to_return(body: FAKE_ITEMS)
  stub_request(:any, "https://foo:bar@sprint.ly/api/products.json").to_return(body: FAKE_PROJECTS)
  WebMock.disable_net_connect!
end

After do
  rm_rf @dirs
  ENV['RUBYLIB'] = @original_rubylib
  ENV['HOME'] = @real_home
  # Scrap everything ready to start again next time
  rm_rf "/tmp"
end
