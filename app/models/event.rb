class Event < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'creator'
end
