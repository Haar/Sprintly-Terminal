Feature: Sly contains the basic functionality required
  In order to interact with Sprint.ly without using it's website
  I want to have a CLI interface
  So I don't have to leave terminal to use Sprint.ly

  Scenario: App just runs
    When I get help for "sly"
    Then the exit status should be 0

  Scenario: Initial setup
    When I run the "sly" install command
    And I fill in my username
    And I fill in my api key
    Then the stdout should contain "Please enter your Sprint.ly username (email):"
    And the stdout should contain "Please enter your Sprint.ly API key:"
    And the stdout should contain "Thanks! Your details are currently stored in ~/.slyrc to authorise your interactions using the Sprint.ly CLI"
    And I should have a ".slyrc" file in my home directory

  Scenario: Setup for project without prior install
    Given I do not have a ".slyrc" file in my home directory
    When I run the "sly" setup command
    Then the stderr should contain "error: You have not setup Sly on your machine yet, please run the sly install command first."

  Scenario: Setup for project after prior install
    Given I have already set up Sly
    And I am in a new project folder
    When I run the "sly" setup command
    And I select the intended project option
    Then I should have a .sly file in my project folder
    And I should see my stored project name in the stdout
    And the stdout should contain "Thanks! That's Sly all setup for the current project, run `sly help` to see the commands available."
