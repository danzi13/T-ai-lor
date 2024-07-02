Team Members:
Ben Kuhn (bk2782)
Jasmine Lou (yl4386)
Michael Danzi (mjd2266)
Sopho Kevlishvili (sk4698)

Instructions to run and test product

To run product:
1. Please run bundle exec rackup --host 0.0.0.0 --port 3001 
2. Type or copy & paste text into the resume text field
   * We have the front end for pdf resume attachments created, but there is an issue
   when the pdf gets tailored in that the tailored resume will not take the input
   resume into account. In our code we have functional pdf reading functionality,
   but saving to the database lost the data that we read from the pdf.
3. Click on 'Upload Resume'
4. Now, Paste your job description into the job description field.
5. Click on the 'T(ai)lor!' button
6. Click on "Resume Editor" to see your T(ai)lored in a text box, where you can edit
   the results.
7. Once your resume has been T(ai)lored, download your new tailored resume!
8. Verify that your resume now is better tailored to the job description than it was
   before.
   
To test product:
1. In the Iteration directory, run 'rake cucumber'
Then, run rspec first, then cucumber:
2. In the Iteration directory, run 'bundle exec rspec'
3. In the Iteration directory, run 'bundle exec cucumber'

Heroku Link: https://pure-river-69411-5cfef20475c9.herokuapp.com/

Github Link: https://github.com/danzi13/Iteration1

This app will take your long resume and tailor itself to the job description using AI!
