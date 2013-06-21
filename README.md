Sly
=================

Project to create a `nice` terminal interface for the Sprint.ly task management tool.

## Current Functionality

- Install
  - Allows Sly to run on your machine using your API credentials
  - Stores your API credentials in a .slyrc file in your HOME directory
- Setup
  - Associate your current working directory with a specific Sprint.ly project
  - Stores a .sly file in the project folder to store the linking details (specifically ID)
- Stories
  - A small overview of the backlog, current and completed columns

### Testing

Unfortunately, the majority of testing (of the Sly CLI) requires a Sprint.ly account - then again, why would you be touching this if you didn't have an account in the first place? :P

To run the suite of tests, simply use the standard `rake` command.

## Change log

v0.0.5 - Add offline support
v0.0.6 - Add automatic item branching
v0.0.7 - Minor fix for item branching
