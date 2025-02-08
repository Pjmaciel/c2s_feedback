class CreateClientProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :client_profiles do |t|
      t.bigint :user_id, null: false
      t.string :cpf, null: false
      t.timestamps
    end

    add_index :client_profiles, :cpf, unique: true
  end
end
