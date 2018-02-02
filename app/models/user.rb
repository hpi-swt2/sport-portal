# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  email                       :string           default(""), not null
#  encrypted_password          :string           default(""), not null
#  reset_password_token        :string
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_name                  :string
#  last_name                   :string
#  admin                       :boolean          default(FALSE)
#  birthday                    :date
#  telephone_number            :string
#  telegram_username           :string
#  favourite_sports            :string
#  provider                    :string
#  uid                         :string
#  avatar_data                 :text
#  team_notifications_enabled  :boolean          default(TRUE)
#  event_notifications_enabled :boolean          default(TRUE)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # https://github.com/plataformatec/devise
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:hpiopenid], password_length: 8..128

  OMNIAUTH_PASSWORD_LENGTH = 32

  validate :password_complexity

  validates :first_name, :last_name, presence: true
  has_many :created_events, class_name: 'Event', primary_key: 'id', foreign_key: 'owner'

  validates :first_name, presence: true
  validates_each :birthday do |record, attribute, value|
    record.errors.add(attribute, I18n.t('activerecord.models.user.errors.future_birthday')) if !value.nil? && value >= Time.now.to_date
  end
  validates_format_of :telephone_number, with: /\A\d*\z/, message: I18n.t('activerecord.models.user.errors.telephone_number_invalid'), allow_nil: true
  validates :uid, uniqueness: { scope: :provider, allow_nil: true }

  def update_without_password(params, *options)
    unless has_omniauth?
      #params.delete :email
    end
    params.delete :current_password
    super params
  end

  def password_complexity
    if password.present?
      not_only_numbers
      four_different_characters
    end
  end

  def not_only_numbers
    errors.add :password, I18n.t('validations.not_only_numbers') unless password.match(/^(?!^\d+$)^.+$/)
  end

  def four_different_characters
    errors.add :password, I18n.t('validations.four_different_characters') if password.chars.uniq.count < 4
  end


  has_and_belongs_to_many :events

  has_many :organizers
  has_many :organizing_events, through: :organizers, source: 'event'

  include ImageUploader::Attachment.new(:avatar)

  has_many :team_users
  has_many :teams, through: :team_users, source: :team
  has_many :non_single_teams, -> { where single: false }, through: :team_users, source: :team
  has_many :team_owners, -> { where is_owner: true }, source: :team_user, class_name: "TeamUser"
  has_many :owned_teams, through: :team_owners, source: :team

  def create_single_team
    team = Team.create(Hash[name: name, private: true, single: true])
    team.owners << self
    team
  end

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

  def name
    "#{first_name} #{last_name}"
  end

  def all_events
    all_events = self.events + self.organizing_events
    (self.teams + self.owned_teams).map { |team| all_events += team.events }
    all_events.uniq
  end

  def has_event_notifications_enabled?
    true
  end

  def has_team_notifications_enabled?
    true
  end

  def email_with_name
    %('#{name}' <#{email}>)
  end

  class << self
    def new_with_session(_, session)
      super.tap do |user|
        if valid_omniauth_session? session
          data = session['omniauth.data']
          user.uid = data['uid']
          user.provider = data['provider']
          user.first_name = data['first_name'] if user.first_name.blank?
          user.last_name = data['last_name'] if user.last_name.blank?
          user.email = data['email'] if user.email.blank?
          user.skip_confirmation!
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
        user.skip_confirmation!
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.password = Devise.friendly_token OMNIAUTH_PASSWORD_LENGTH
      end
    end
  end
end
