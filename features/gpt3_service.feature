Feature: Testing Gpt3Service

  Scenario: Calling the Gpt3Service
    Given I have a message "Write back to me just the phrase 'Hello' and nothing else."
    When I call the Gpt3Service
    Then the response should be "Hello"