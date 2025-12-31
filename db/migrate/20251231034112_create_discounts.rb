class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :percentage, precision: 5, scale: 2 # e.g., 10.00 for 10%
      t.integer :fixed_amount # cents, alternative to percentage
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :discounts, :name
    add_index :discounts, :active
  end
end
