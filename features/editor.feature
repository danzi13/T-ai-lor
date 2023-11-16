Feature: editing a resume 

Background: user on website
  Given I am on the editor page

Scenario: save changes for resume editor
  When I press "Save"
  Then I should see "Success! Resume Updated"
  And I am on the uploaded page

Scenario: cancel changes for resume editor
  When I follow "Cancel"
  Then I am on the uploaded page
  And I should see "Paste your job description"

Scenario: return to home page
  When I follow "Upload a New Resume"
  Then I am on the resume page

Scenario: see some text in the editor console
  When I go to Enter Resume Text
  And I fill in "Resume Text" with "my resume text"
  And I press "Upload Resume"
  And I am on the uploaded page
  And I follow "Resume Editor"
  Then I am on the editor page
  And I should see "No resume was tailored"
  And the resume textarea should contain "No Resume"