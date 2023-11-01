Feature: upload job description on t(AI)lor

Background: user on website
  Given the user is on the job description page of t(AI)lor
  And Resume uploaded successfully

Scenario: add job description
  When I fill in "Job Description"
  And I press "Upload Job Description"
  Then I should see "Success! You can preview or download"

Scenario: job description not added
  When "Job Description" is empty
  And I press "Upload Job Description"
  Then I should see "No description, try again"