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

  Scenario: Setup for project
    Given I do not have a ".slyrc" file in my home directory"
    When I run the "sly" setup command
    Then the stderr should contain "error: You have not setup Sly on your machine yet, please run the sly install command first."
