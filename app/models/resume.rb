class Resume < ActiveRecord::Base
  has_one_attached :attachment

  validates :attachment, presence: true, if: -> { resume_text.blank? }
  validates :resume_text, presence: true, if: -> { attachment.blank? }

end
