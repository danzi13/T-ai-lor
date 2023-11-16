Feature: Testing Gpt3Service

  Scenario: Calling the Gpt3Service
    Given I have a message "Write back to me just the phrase 'Hello' and nothing else."
    When I call the Gpt3Service
    Then the response should be "Hello"

  Scenario: Save a resume with GPT returning a non-empty tailored resume
  Given a resume with a non-empty tailored resume
  When I save the resume
  Then the resume should be saved successfully

  Scenario: Save a resume with GPT returning an empty tailored resume
    Given a resume with an empty tailored resume
    When I save the resume
    Then the resume shouldn't be saved successfully

  Scenario: Save a resume with GPT returning a tailored resume containing newline characters
    Given a resume with a tailored resume containing newline characters
    When I save the resume
    Then the resume should be saved successfully

  Scenario: Tailor a resume section containing 'skills'
    Given a resume section with the word 'skills'
    When I tailor the resume section
    Then the tailored resume should contain the tailored section

  Scenario: Tailor a resume section containing 'work'
    Given a resume section with the word 'work'
    When I tailor the resume section
    Then the tailored resume should contain the tailored section

  Scenario: Tailor a resume section containing 'experience'
    Given a resume section with the word 'experience'
    When I tailor the resume section
    Then the tailored resume should contain the tailored section

  Scenario: Tailor a resume section without 'skills', 'work', or 'experience'
    Given a resume section without 'skills', 'work', or 'experience'
    When I tailor the resume section
    Then the tailored resume should contain the original section