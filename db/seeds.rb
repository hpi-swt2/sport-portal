# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

admin = User.new(
  first_name: 'admin',
  last_name: '',
  email: 'admin@example.com',
  password: 'a',
  password_confirmation: 'a',
  admin: true)

# Skip validations, so that e.g. a short password is possible
admin.save(validate: false)

# Some example user entries

User.new(
  first_name: 'Nilrem',
  last_name: 'Eyah al ed',
  email: 'wizard@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1996, 10, 21),
  telegram_username: 'mldh',
  telephone_number: '0815421337',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar1.png"),
  favourite_sports: 'Userstory-Wett-Schreiben',
  contact_information: 'Im Büro 312-3').save(validate: false)

User.new(
  first_name: 'Sukram',
  last_name: 'Dnarb',
  email: 'cuber@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1997, 3, 29),
  telegram_username: 'mb',
  telephone_number: '987654321',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar2.gif"),
  favourite_sports: 'Userstory-Wett-Lösen',
  contact_information: 'Facebook: sukram_dnarb').save(validate: false)

User.new(
  first_name: 'Kire',
  last_name: 'Lednerb',
  email: 'gummi.ente@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1997, 8, 10),
  telegram_username: 'eb',
  telephone_number: '12345654321',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar3.png"),
  favourite_sports: 'Hardcore-Couching',
  contact_information: 'Twitter: @kireLdenerb').save(validate: false)

sports = %w(Fußball Basketball Tennis)

6.times do
  sports.shuffle

  User.new(
    first_name: Faker::Name.unique.first_name,
    last_name: Faker::Name.unique.last_name,
    email: Faker::Internet.unique.email,
    password: 'seed1234',
    password_confirmation: 'seed1234',
    birthday: Faker::Date.birthday(18, 65),
    telegram_username: 'eb',
    telephone_number: '12345654321',
    avatar: File.open("#{Rails.root}/db/seed_data/avatar3.png"),
    favourite_sports: sports[rand(sports.length), rand(sports.length - 1) + 1].join(', '),
    contact_information: 'My Homepage: example.com').save(validate: false)
end

# Some exmaple event entries
League.new(
  name: 'Old League',
  description: 'A league, that is outdated.',
  discipline: 'Soccer',
  player_type: 1,
  max_teams: 20,
  game_mode: 1,
  type: 'League',
  created_at: Date.yesterday,
  updated_at: Date.yesterday,
  startdate: Date.yesterday,
  enddate: Date.yesterday,
  deadline: Date.yesterday,
  gameday_duration: 1,
  owner_id: nil).save(validate: false)
