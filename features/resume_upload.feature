Feature: upload resume on t(AI)lor

Background: user on website
  Given the user is on the resume page of t(AI)lor

Scenario: add resume by pasting into textbox
  When I fill in "Title"
  And I press "Continue"
  Then I should see "Paste your job description:"

Scenario: add resume by upload a file
  When I press "Choose File"
  And I attach a file named "my_resume.pdf"
  And I press "Continue"
  Then I should see "Paste your job description:"
