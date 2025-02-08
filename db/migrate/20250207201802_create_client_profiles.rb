class CreateClientProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :client_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :cpf, unique: true

      t.timestamps
    end
  end
end
