class CreateMaintenanceTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenance_teams do |t|
      t.string :name, null: false
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
