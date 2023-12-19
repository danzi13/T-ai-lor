Feature: upload resume on t(AI)lor

Background: user on website
  Given I am on on the resume page

Scenario: add resume by pasting into textbox
  When I go to Enter Resume Text
  And I fill in "Resume Text" with "my resume text"
  And I press "Upload Resume"
  Then I am on the uploaded page
  And I should see "Paste your job description"

Scenario: add resume by upload a file
  When I go to the resume page
  And I go to Choose File
  And I attach the file "my_resume.pdf"
  And I press "Upload Resume"
  Then I am on the uploaded page
  And I should see "Paste your job description"

Scenario: upload a resume without providing input
  When I go to the resume page
  And I press "Upload Resume"
  Then I should be on the resume page
  And I should see "Upload Your Resume"

Scenario: Unsuccessful resume upload
  When I go to the resume page
  And I go to Choose File
  And I attach an invalid file
  And I press "Upload Resume"
  Then I should be on the resume page
  And I should see "Upload Your Resume"
