class MaintenanceTeam < ApplicationRecord
  belongs_to :department

  has_many :team_members
  has_many :technicians,
           through: :team_members,
           source: :user

  has_many :equipment
  has_many :maintenance_requests

  validates :name, presence: true
end
