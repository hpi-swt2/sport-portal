# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = FactoryBot.build(:user,
  first_name: 'admin',
  last_name: '',
  email: 'admin@example.com',
  password: 'a',
  password_confirmation: 'a',
  admin: true)

# Skip validations, so that e.g. a short password is possible
admin.save(validate: false)

FactoryBot.create(:match)

# Some example user entries

FactoryBot.build(:user,
  first_name: 'Nilrem',
  last_name: 'Eyah al ed',
  email: 'wizard@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1996, 10, 21),
  telegram_username: 'mldh',
  telephone_number: '0815421337',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar1.png"),
  favourite_sports: 'Userstory-Wett-Schreiben').save(validate: false)

FactoryBot.build(:user,
  first_name: 'Sukram',
  last_name: 'Dnarb',
  email: 'cuber@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1997, 3, 29),
  telegram_username: 'mb',
  telephone_number: '987654321',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar2.gif"),
  favourite_sports: 'Userstory-Wett-Lösen').save(validate: false)

FactoryBot.build(:user,
  first_name: 'Kire',
  last_name: 'Lednerb',
  email: 'gummi.ente@hpi.de',
  password: 'seed1234',
  password_confirmation: 'seed1234',
  birthday: Date.new(1997, 8, 10),
  telegram_username: 'eb',
  telephone_number: '12345654321',
  avatar: File.open("#{Rails.root}/db/seed_data/avatar3.png"),
  favourite_sports: 'Hardcore-Couching').save(validate: false)