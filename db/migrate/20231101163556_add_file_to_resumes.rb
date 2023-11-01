class AddFileToResumes < ActiveRecord::Migration[6.0]
  def change
    add_column :resumes, :file, :blob
  end
end
