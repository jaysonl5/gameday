class AddRecurringBooleanToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :recurring, :boolean, default: false, null: false
    
    # Populate existing records based on source field
    reversible do |dir|
      dir.up do
        Payment.where(source: 'Recurring').update_all(recurring: true)
      end
    end
  end
end