class CreateTeamMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :team_members do |t|
      t.references :user, null: false, foreign_key: true
      t.references :maintenance_team, null: false, foreign_key: true

      t.timestamps
    end

    add_index :team_members, [:user_id, :maintenance_team_id], unique: true
  end
end
