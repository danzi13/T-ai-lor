Feature: upload resume on t(AI)lor

Background: user on website
  Given I am on on the resume page

Scenario: add resume by pasting into textbox
  When I go to Enter Resume Text
  And I fill in "Resume Text" with "my resume text"
  And I press "Submit Text" within the form
  Then I should see "Paste your job description:"

Scenario: add resume by upload a file
  When I go to the resume page
  And I go to Choose File
  And I attach the file "my_resume.pdf"
  And I press "Upload Resume" within resume
  Then I am on the uploaded page
  And I should see "Resume uploaded successfully."
