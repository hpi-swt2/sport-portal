class AvatarUploader < Shrine
  plugin :validation_helpers, default_messages: {
      max_size: ->(max) { I18n.t("users.avatar.errors.max_size", max: max) },
      mime_type_inclusion: ->(whitelist) { I18n.t("users.avatar.errors.mime_type_inclusion", whitelist: whitelist) },
  }
  plugin :remove_attachment
  plugin :determine_mime_type

  Attacher.validate do
    validate_max_size 2.megabytes
    validate_mime_type_inclusion %w[image/jpeg image/gif image/png]
  end
end
