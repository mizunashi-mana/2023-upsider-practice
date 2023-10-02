class CreateCustomerBankAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :customer_bank_accounts, id: { type: :string, limit: 26 } do |t|
      t.references :owner_customer, type: :string, null: false
      t.string :name, limit: 510, null: false
      t.blob :others, null: false

      t.timestamps
    end
  end
end
