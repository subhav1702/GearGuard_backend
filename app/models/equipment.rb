class Equipment < ApplicationRecord
  belongs_to :department
  belongs_to :maintenance_team

  belongs_to :owner,
             class_name: "User",
             optional: true

  belongs_to :default_technician,
             class_name: "User",
             optional: true

  has_many :maintenance_requests

  validates :name, :serial_number, presence: true
end
