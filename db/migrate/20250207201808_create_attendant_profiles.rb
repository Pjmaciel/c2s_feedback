class CreateAttendantProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :attendant_profiles do |t|
      t.bigint :user_id, null: false
      t.string :registration_number, null: false
      t.timestamps
    end

    add_index :attendant_profiles, :registration_number, unique: true
  end
end
