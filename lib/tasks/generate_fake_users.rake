require 'faker'

desc 'Generate 10 fake user account'
task generate_fake_users: :environment do
  sports = %w(Fussball Tennis Volleyball Golf Tischtennis)

  10.times do
    sports.shuffle
    password = Faker::Internet.password
    User.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.unique.email,
      birthday: Faker::Time.between(50.years.ago, 15.years.ago, :all),
      telephone_number: rand(100000000000..99999999999),
      favourite_sports: sports[rand(sports.length), rand(sports.length - 1) + 1].join(', '),
      password: password,
      password_confirmation: password
    )
  end
end