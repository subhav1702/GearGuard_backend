class MaintenanceRequest < ApplicationRecord
  belongs_to :equipment
  belongs_to :maintenance_team
  belongs_to :technician,
             class_name: "User",
             optional: true

  enum request_type: {
    corrective: "corrective",
    preventive: "preventive"
  }

  STATES = %w[new in_progress repaired scrap]

  validates :state, inclusion: { in: STATES }

  scope :overdue, -> {
    where("scheduled_at < ? AND state != ?", Time.current, "repaired")
  }
end
