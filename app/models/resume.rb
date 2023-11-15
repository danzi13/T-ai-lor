class Resume < ActiveRecord::Base
  has_one_attached :attachment
  attr_accessor :resume_text
  validates :resume_text, presence: true

  # validates_attachment_content_type :file, content_type: ['application/pdf', 'application/msword', 'text/plain']

  # validates :file, attached: true, content_type: ['application/pdf', 'application/msword', 'text/plain']

  # validates :file,
  # attached: true, # Ensure that a file is attached
  # content_type: ['application/pdf', 'application/msword', 'text/plain']

  # attr_accessor :resume_text
  # attr_accessor :filename
  # has_attached_file :file

  # validates_attachment :file,
  #   content_type: { content_type: ["application/pdf", "application/msword", "text/plain"] },
  #   presence: true

  # validates :resume_text, presence: true

end
