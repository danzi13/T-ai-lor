class Resume < ActiveRecord::Base
   #has_attached_file :file
   has_one_attached :file
   attr_accessor :file_file_name
   attr_accessor :file_content_type
   attr_accessor :file_file_size

   validates_attachment :file,
    presence: true, # Ensure that a file is attached
    content_type: { content_type: ["application/pdf", "application/msword", "text/plain"]    }
end
