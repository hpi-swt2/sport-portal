class AvatarUploader < Shrine
  plugin :validation_helpers
  plugin :remove_attachment
  plugin :determine_mime_type

  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/gif image/png]
    validate_max_size 2.megabytes, message: t('users.avatar.errors.too_large')
  end
end