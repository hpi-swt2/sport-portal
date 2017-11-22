class Avatar < ApplicationRecord
  belongs_to :user
  include AvatarUploader::Attachment.new(:image)
end
