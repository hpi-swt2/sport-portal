FactoryGirl.define do
  factory :match do
    date "2017-10-23"
    place "Place"
    association :team_away, :factory => :team
    association :team_home, :factory => :team
    score_home 12
    score_away 13
  end
end
