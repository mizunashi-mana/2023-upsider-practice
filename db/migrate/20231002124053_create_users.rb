class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: { type: :string, limit: 26 } do |t|
      t.string :email, limit: 510, null: false
      t.string :password_digest, null: false

      t.references :organization, type: :string, null: false
      t.blob :authority_on_organization, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
