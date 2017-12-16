class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.event_enums_name(model_name, enum_name, enum_key)
    I18n.t("events.#{model_name.to_s.downcase}.#{enum_name.to_s.pluralize}.#{enum_key}")
  end
end
