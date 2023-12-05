class AddResumeTextToResumes < ActiveRecord::Migration[6.0]
  def change
    add_column :resumes, :resume_text, :text
  end
end
