require 'fileutils'

include FileUtils

ARUBA_PREFIX = "aruba/tmp/"

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^I run the "(.*?)" (.*?) command$/ do |app_name, command|
  @app_name = app_name
  step %(I run `#{app_name} #{command}` interactively)
end

When /^I fill in my username$/ do
  step %(I type "#{ENV["sprintly_email"]}")
end

When /^I fill in my api key$/ do
  step %(I type "#{ENV["sprintly_api_key"]}")
end

And /^I should have a "([^"]*)" file in my home directory$/ do |file_name|
  File.exists?(ENV["HOME"]+"/"+file_name).should be_true
end

Given /^I have already set up Sly$/ do
  steps %Q{
    When I run the "sly" install command
    And I fill in my username
    And I fill in my api key
    Then the stdout should contain "Thanks! Your details are currently stored in ~/.slyrc to authorise your interactions using the Sprint.ly CLI"
  }
end

Given /^I do not have a "(.*?)" file in my home directory$/ do |file_name|
  File.delete(ENV["HOME"]+"/"+file_name) if File.exists?(ENV["HOME"]+"/"+file_name)
end

Given /^I am in a new project folder$/ do
  project_folder = "project"
  mkdir "tmp/aruba/project"
  cd project_folder
end

When /^I select the intended project option$/ do
  step %{I type "#{ENV["sprintly_product_id"]}"}
end

Then /^I should have a \.sly file in my project folder$/ do
  File.exists?(".sly").should be_true
end

Given /^I have already setup my project folder$/ do
  @project = Sly::Project.new({"archived" => false,
                               "name"     => ENV["sprintly_product_name"],
                               "admin"    => true,
                               "id"       => ENV["sprintly_product_id"].to_i})
  @stub_connector = stub(:connector)
  @stub_connector.stub(:items_for_product).with(@project.id).and_return(YAML::load(File.open("spec/fixtures/items.yml")))
  Sly::Connector.stub(:connect_with_defaults).and_return(@stub_connector)
  @project.update
  ls
end
