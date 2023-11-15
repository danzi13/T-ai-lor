Feature: upload job description on t(AI)lor

Background: user on website
  Given I am on the uploaded page

Scenario: add job description
  When I fill in "description" with "This is the job description"
  And I follow "T(ai)lor!"
  Then I should see "Success! You can preview or download"

Scenario: job description not added

  When I fill in "description" with ""
  And I press "T(ai)lor!"
  Then I should see "No description, try again"

Scenario: return to home page
  When I follow "Upload a New Resume"
  Then I am on the resume page

Scenario: editor without tailoring
  When I follow "Resume Editor"
  And I am on the editor page
  Then I should see "No resume was tailored"

Scenario: editor with tailoring
  Given I am on the uploaded page
  And I press "T(ai)lor!"
  And I press "Resume Editor"
  Then I am on the editor page
