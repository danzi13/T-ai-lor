class CreateResumes < ActiveRecord::Migration[6.0]
  def change
    unless table_exists?(:resumes)
      create_table :resumes do |t|

        t.string :name
        t.text :content

        t.timestamps
      end
    end
  end
end
