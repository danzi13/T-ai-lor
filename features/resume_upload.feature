Feature: upload resume on t(AI)lor

Background: user on website
  Given I am on on the resume page

Scenario: add resume by pasting into textbox
  When I go to Enter Resume Text
  And I fill in "Resume Text" with "my resume text"
  And I press "Continue"
  Then I should see "Paste your job description:"

Scenario: add resume by upload a file
  When I go to the resume page
  And I press "Choose File"
  And I attach a file named "my_resume.pdf"
  And I press "Continue"
  Then I should see "Paste your job description:"
