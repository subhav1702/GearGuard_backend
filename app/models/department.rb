class Department < ApplicationRecord
  has_many :equipment
  has_many :maintenance_teams

  validates :name, presence: true
end
