FactoryBot.define do
  factory :tournament, parent: :event, traits: [:has_dates], class: Tournament do
  end
end
