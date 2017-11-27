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
#  birthday               :date
#  telephone_number       :string
#  telegram_username      :string
#  favourite_sports       :string
#  provider               :string
#  uid                    :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # https://github.com/plataformatec/devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:hpiopenid]

  validates :first_name, presence: true
  validates_each :birthday do |record, attribute, value|
    record.errors.add(attribute, I18n.t('activerecord.models.user.errors.future_birthday')) if !value.nil? && value >= Time.now.to_date
  end
  validates_format_of :telephone_number, with: /\A\d+\z/, message: I18n.t('activerecord.models.user.errors.telephone_number_invalid'), allow_nil: true
  validates :uid, uniqueness: { scope: :provider, allow_nil: true }

  has_many :organizers
  has_many :organizing_events, :through => :organizers, :source => 'event'

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
