Feature: upload job description on t(AI)lor

Background: user on website
  Given I am on the uploaded page

Scenario: add job description
  Given there is a resume in the database
  When I fill in "description" with "This is the job description"
  And I try to tailor by pressing "T(ai)lor!"
  Then I should see "Success! You can preview or download"

Scenario: job description not added
  When I fill in "description" with ""
  And I try to tailor by pressing "T(ai)lor!"
  Then I should see "No description, try again"

Scenario: return to home page
  When I follow "Upload New Resume"
  Then I am on the resume page

Scenario: editor without tailoring
  When I follow "Resume Editor"
  And I am on the editor page
  Then I should see "No resume was tailored"

Scenario: editor with tailoring
  Given I am on the uploaded page
  And I try to tailor by pressing "T(ai)lor!"
  And I try to tailor by pressing "Resume Editor"
  Then I am on the editor page