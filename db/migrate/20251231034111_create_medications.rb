class CreateMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :medications do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :default_dose, precision: 5, scale: 2 # ml/week
      t.json :typical_vial_sizes # [10, 5, 2.5]
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :medications, :name, unique: true
    add_index :medications, :active
  end
end
