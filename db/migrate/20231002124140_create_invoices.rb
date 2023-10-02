class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices, id: { type: :string, limit: 26 } do |t|
      t.references :issued_customer, type: :string, null: false
      t.integer :status, null: false

      t.date :issued_date, null: false
      t.date :payment_due_date, null: false
      t.integer :payment_amount_jpy, null: false
      t.integer :claimed_amount_jpy, null: false

      t.blob :others, null: false

      t.timestamps
    end
    add_index :invoices, [:payer_organization_id, :payment_due_date], name: 'index_invoices_on_org_and_duedt'
  end
end
