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

Given /^I do not have a "(.*?)" file in my home directory"$/ do |file_name|
  File.delete(ENV["HOME"]+"/"+file_name) if File.exists?(ENV["HOME"]+"/"+file_name)
end
