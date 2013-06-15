require 'sly'
require 'cucumber/rspec/doubles'

include FileUtils

ARUBA_PREFIX = "tmp/aruba"

When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^I run the "(.*?)" (.*?) command$/ do |app_name, command|
  @app_name = app_name
  step %(I run `#{app_name} #{command}` interactively)
end

And /^I should have a "([^"]*)" file in my home directory$/ do |file_name|
  File.exists?(ENV["HOME"]+"/"+file_name).should be_true
end

Given /^I have already set up Sly$/ do
  File.open(File.join(ENV["HOME"], ".slyrc"), "w") { |f| f.write "foo:bar" }
end

Given /^I do not have a "(.*?)" file in my home directory$/ do |file_name|
  File.delete(ENV["HOME"]+"/"+file_name) if File.exists?(File.join(ENV["HOME"], file_name))
end

Given /^I am in a new project folder$/ do
  project_folder = "project"
  create_dir project_folder
  cd project_folder
end

When /^I select the intended project option$/ do
  step %{I type "#{ENV["sprintly_product_id"]}"}
end

Then /^I should have a \.sly file in my project folder$/ do
  File.exists?(".sly").should be_true
end

Given /^I have already setup my project folder$/ do
  step %(I am in a new project folder)
  @project = Sly::Project.new({"archived" => false,
                               "name"     => ENV["sprintly_product_name"],
                               "admin"    => true,
                               "id"       => ENV["sprintly_product_id"].to_i})
  @stub_connector = stub(:connector)
  @stub_connector.stub(:items_for_product).and_return(YAML::load(File.open("spec/fixtures/items.yml")))
  Sly::Connector.stub(:connect_with_defaults).and_return(@stub_connector)
  Sly::Project.stub(:load).and_return(@project)

  create_dir '.sly'
  write_file '.sly/project', @project.to_yaml
  @project.update
  @project.stub(:update)
end

When /^I install sly using a correct username and api key$/ do
  stub_request(:get, "https://foo:bar@sprint.ly/api/products.json").to_return(body: "[]")
  stub_request(:get, "https://sprint.ly/api/products.json").to_return(body: "[]")
  steps %Q{
    When I run the "sly" install command
    And I type "foo"
    And I type "bar"
  }
end

Then /^I should see the output has asked me for my details$/ do
  steps %Q{
    Then the output should contain "Please enter your Sprint.ly username (email):"
    And the output should contain "Please enter your Sprint.ly API key:"
  }
end

Then /^I should see that it has authorised correctly$/ do
  steps %Q{
    And the output should contain "Thanks! Your details are currently stored in ~/.slyrc to authorise your interactions using the Sprint.ly CLI"
    And I should have a ".slyrc" file in my home directory
  }
end

When /^I try the same step again$/ do
end
