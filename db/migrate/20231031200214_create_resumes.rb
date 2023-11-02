class CreateResumes < ActiveRecord::Migration[6.0]
  def change
    create_table :resumes do |t|
      t.string :title
      t.attachment :attachment
      t.resume_text :resume_text

      t.timestamps null: false
    end
  end
end
