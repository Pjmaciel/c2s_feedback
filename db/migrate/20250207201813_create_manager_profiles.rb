class CreateManagerProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :manager_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :registration_number , null: false
      t.timestamps
    end

    add_index :manager_profiles, :registration_number, unique: true
  end
end
