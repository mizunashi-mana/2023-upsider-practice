class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations, id: { type: :string, limit: 26 } do |t|
      t.string :name, limit: 510, null: false
      t.blob :others, null: false

      t.timestamps
    end
  end
end
