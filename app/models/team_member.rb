class TeamMember < ApplicationRecord
  belongs_to :user
  belongs_to :maintenance_team
end
