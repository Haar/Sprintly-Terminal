Feature: Sly Helper
  In order to understand how to use Sly properly
  I want a help method that explains the use cases
  So I don't have to memorise it's usage

  Scenario: Using the overall help command
    When I get help for "Sly"
    Then the exit status should be 0

