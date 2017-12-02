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

  validates :first_name, presence: true
  validates :uid, uniqueness: { scope: :provider, allow_nil: true }


  has_and_belongs_to_many :events

  has_many :organizers
  has_many :organizing_events, :through => :organizers, :source => 'event'

  include AvatarUploader::Attachment.new(:image)

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



  class << self
    def new_with_session(_, session)
      super.tap do |user|
        if valid_omniauth_session? session
          data = session['omniauth.data']
          user.uid = data['uid']
          user.provider = data['provider']
          user.email = data['email'] if user.email.blank?
        end
      end
    end

    def valid_omniauth_session?(session)
      data = session['omniauth.data']
      return data['expires'].to_time > Time.current if data
      false
    end

    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
      end
    end
  end
end
