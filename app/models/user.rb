class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  rolify

  def self.from_omniauth(auth)
    # First, try to find user by provider and uid (existing OAuth user)
    user = where(provider: auth.provider, uid: auth.uid).first

    # If not found, try to find by email (existing email/password user)
    user ||= where(email: auth.info.email).first

    # If still not found, create a new user
    if user.nil?
      user = new(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        name: auth.info.name,
        avatar_url: auth.info.image,
        approved: false  # Requires admin approval
      )
    else
      # Update existing user with OAuth info if they don't have it
      user.provider = auth.provider if user.provider.blank?
      user.uid = auth.uid if user.uid.blank?
      user.name = auth.info.name if user.name.blank?
      user.avatar_url = auth.info.image if user.avatar_url.blank?
    end

    user.save
    user
  end

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end
end
