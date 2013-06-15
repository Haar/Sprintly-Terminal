Feature: Sly contains the basic functionality required
  In order to interact with Sprint.ly without using it's website
  I want to have a CLI interface
  So I don't have to leave terminal to use Sprint.ly

  Scenario: App just runs
    When I get help for "sly"
    Then the exit status should be 0

  Scenario: Initial install
    When I install sly using a correct username and api key
    Then I should see the output has asked me for my details
    And I should see that it has authorised correctly

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
    And the output should contain "Thanks! That's Sly all setup for the current project, run `sly help` to see the commands available."

  Scenario: Sly Backlog
    Given I have already set up Sly
    And I have already setup my project folder
    When I run `sly backlog`
    Then the output should contain "Backlog"
    And the output should contain "208"
    And the output should contain "Add the ability to reply to comments via email."

  Scenario: Sly Current
    Given I have already set up Sly
    And I have already setup my project folder
    When I run `sly current`
    Then the stderr should contain "bar"
    Then the output should contain "Current"
    And the output should contain "188"
    And the output should contain "Don't let un-scored items out of the backlog."
