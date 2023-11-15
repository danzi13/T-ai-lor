class Resume < ActiveRecord::Base
  # has_one_attached :attachment
  # attr_accessor :resume_text
  # validates :resume_text, presence: true

  has_one_attached :attachment
  validates :file, presence: true, if: -> { resume_text.blank? }
  validates :resume_text, presence: true, if: -> { file.blank? }

  # validates :file,
  # attached: true, # Ensure that a file is attached
  # content_type: ['application/pdf', 'application/msword', 'text/plain']

end
