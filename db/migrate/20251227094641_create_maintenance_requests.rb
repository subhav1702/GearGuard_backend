class CreateMaintenanceRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :maintenance_requests do |t|
      t.string :subject, null: false
      t.string :request_type, null: false
      t.string :state, null: false, default: "new"
      t.datetime :scheduled_at
      t.integer :duration
      t.references :equipment, null: false, foreign_key: true
      t.integer :technician_id
      t.integer :maintenance_team_id

      t.timestamps
    end

    add_index :maintenance_requests, :state
    add_index :maintenance_requests, :request_type
    add_index :maintenance_requests, :scheduled_at
  end
end
