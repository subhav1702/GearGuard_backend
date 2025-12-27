require "securerandom"
require "digest"

class User < ApplicationRecord
  has_secure_password

  TOKEN_EXPIRY = 30.minutes

  enum role: {
    employee: "employee",
    technician: "technician",
    manager: "manager"
  }

  has_many :owned_equipment,
           class_name: "Equipment",
           foreign_key: :owner_id

  has_many :assigned_requests,
           class_name: "MaintenanceRequest",
           foreign_key: :technician_id

  has_many :team_memberships
  has_many :maintenance_teams, through: :team_memberships

  validates :email, presence: true, uniqueness: true

  def generate_reset_password_token!
    raw_token = SecureRandom.hex(20)
    hashed = Digest::SHA256.hexdigest(raw_token)

    update!(
      reset_password_token: hashed,
      reset_password_sent_at: Time.current
    )

    raw_token
  end

  def reset_token_valid?(token)
    return false if reset_password_sent_at.blank?

    hashed = Digest::SHA256.hexdigest(token)

    hashed == reset_password_token &&
      reset_password_sent_at > TOKEN_EXPIRY.ago
  end

  def clear_reset_password_token!
    update!(
      reset_password_token: nil,
      reset_password_sent_at: nil
    )
  end
end
