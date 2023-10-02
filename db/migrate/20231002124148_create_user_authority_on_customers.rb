class CreateUserAuthorityOnCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_authority_on_customers, id: { type: :string, limit: 26 } do |t|
      t.references :customer, type: :string, null: false
      t.references :user, type: :string, null: false

      t.blob :others, null: false

      t.timestamps
    end
    add_index :user_authority_on_customers, [:customer_id, :user_id],
      name: 'index_user_auth_on_cust_ids',
      unique: true
  end
end
