class CreateDebts < ActiveRecord::Migration[7.2]
  def change
    create_table :debts do |t|
      t.float :amount
      t.string :description
      t.boolean :is_paid
      t.integer :payer_id
      t.integer :payee_id
      t.integer :group_id

      t.timestamps
    end
  end
end
