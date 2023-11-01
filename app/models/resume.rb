class Resume < ActiveRecord::Base
  # has_one_attached :attachment
  attr_accessor :resume_text

  #validates :file,
   # attached: true, # Ensure that a file is attached
    #content_type: ['application/pdf', 'application/msword', 'text/plain']

end
