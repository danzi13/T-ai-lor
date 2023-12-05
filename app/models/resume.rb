class Resume < ActiveRecord::Base
  has_one_attached :attachment

  attribute :title, :string unless column_names.include?('title')
  validates :attachment, presence: true, if: -> { resume_text.blank? }
  validates :resume_text, presence: true, if: -> { attachment.blank? }

end
