Feature: Generating PDF in the controller

  Scenario: Generate PDF with content
    Given I have some content
    When I generate a PDF with that content
    Then I should receive a non-empty PDF content

