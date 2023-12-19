Feature: Downloading tailored resume as PDF

  Background:
    Given I am on the uploaded page

  Scenario: Download tailored resume with content
    Given there is a tailored resume with content
    When I press "Download Resume"
    Then I should download the tailored resume as a PDF

  Scenario: Attempt to download without a tailored resume
    Given there is no tailored resume
    When I press "Download Resume"
    Then I should see a message indicating no tailored resume is available