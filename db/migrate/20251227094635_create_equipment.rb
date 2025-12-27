class CreateEquipment < ActiveRecord::Migration[7.1]
  def change
    create_table :equipment do |t|
      t.string :name, null: false
      t.string :serial_number, null: false
      t.string :location
      t.date :purchase_date
      t.date :warranty_expiry
      t.boolean :is_scrapped, default: false
      t.references :department, null: false, foreign_key: true
      t.references :maintenance_team, null: false, foreign_key: true
      t.integer :default_technician_id
      t.integer :owner_id

      t.timestamps
    end

    add_index :equipment, :serial_number, unique: true
  end
end
