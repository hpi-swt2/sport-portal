# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # https://github.com/plataformatec/devise
  devise :database_authenticatable, :registerable,
      :recoverable, :rememberable, :validatable, :omniauthable

  validates :first_name, presence: true

  # Avatars
  has_attached_file :avatar,
    styles: { medium: "300x300>", thumb: "100x100>", square: "100x100" },
    default_url: "/images/:style/missing.png"
  validates_attachment :avatar,
    content_type: { content_type: /\Aimage\/.*\z/ },
    size: { in: 0..2.megabytes }
end
