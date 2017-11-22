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
#  provider               :string
#  uid                    :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # https://github.com/plataformatec/devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:hpiopenid]

  validates :first_name, :last_name, presence: true
  validates :uid, uniqueness: { scope: :provider, allow_nil: true }

  def has_omniauth?
    provider.present? && uid.present?
  end

  def omniauth=(auth)
    self.uid = auth.uid
    self.provider = auth.provider
  end

  def reset_omniauth
    self.uid = nil
    self.provider = nil
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end
end
