Given(/^(\d*) teams$/) do |count|
  (1..count).each { |num| create_team_named("team#{num}", name: "team#{num}") }
end

Given(/^(?:a|one) team$/) do
  create_team
end

Given(/^a team (.*)$/) do |name|
  create_team_named(name, name: name)
end
