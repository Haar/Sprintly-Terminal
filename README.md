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
- Branching
  - Lets you create (if required) and checkout a named branch for a specific story, grouped into folders by their type

### Testing

Unfortunately, the majority of testing (of the Sly CLI) requires a Sprint.ly account - then again, why would you be touching this if you didn't have an account in the first place? :P

To run the suite of tests, simply use the standard `rake` command.

## Change log

  - v0.0.5  - Add offline support
  - v0.0.6  - Add automatic item branching
  - v0.0.7  - Minor fix for item branching
  - v0.0.8  - Remove unimplemented functionality from help
  - v0.0.9  - Minor fix for item colour breakage
  - v0.0.10 - Update website details
  - v0.0.11 - Add license details to gemspec
  - v0.0.12 - Display error to user when attempting to use a Ruby version < 1.9.2

## Licensing

<p xmlns:dct="http://purl.org/dc/terms/" xmlns:vcard="http://www.w3.org/2001/vcard-rdf/3.0#">
  <a rel="license"
     href="http://creativecommons.org/publicdomain/zero/1.0/">
    <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
  </a>
  <br />
  To the extent possible under law,
  <a rel="dct:publisher"
     href="www.tallguyrob.com">
    <span property="dct:title">Robert White</span></a>
  has waived all copyright and related or neighboring rights to
  <span property="dct:title">Sly</span>.
This work is published from:
<span property="vcard:Country" datatype="dct:ISO3166"
      content="GB" about="www.tallguyrob.com">
  United Kingdom</span>.
</p>
