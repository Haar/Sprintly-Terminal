When /^I get help for "([^"]*)"$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} help`)
end

When /^I run the "(.*?)" install command$/ do |app_name|
  @app_name = app_name
  step %(I run `#{app_name} install` interactively)
end

When /^I fill in my username$/ do
  step %(I type "#{ENV["sprintly_email"]}")
end

When /^I fill in my api key$/ do
  step %(I type "#{ENV["sprintly_api_key"]}")
end
