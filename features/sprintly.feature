Feature: My bootstrapped app kinda works
  In order to get going on coding my awesome app
  I want to have aruba and cucumber setup
  So I don't have to do it myself

  Scenario: App just runs
    When I get help for "sprintly"
    Then the exit status should be 0

  Scenario: Initial setup
    When I run the "sprintly" install command
    And I fill in my username
    And I fill in my api key
    Then the stdout should contain "Please enter your Sprint.ly username (email):"
    And the stdout should contain "Please enter your Sprint.ly API key:"
    And the stdout should contain "Thanks! Your details are currently stored in ~/.sprintlyrc to authorise your interactions using the Sprint.ly CLI"
    # And I should have a .sprintlyrc file in my home directory
