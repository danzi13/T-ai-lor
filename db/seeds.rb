resumes = [
  {
    attachment: nil,
    resume_text: 'Hi'
  }
]


resumes.each do |resume|
  Resume.create!(resume)
end