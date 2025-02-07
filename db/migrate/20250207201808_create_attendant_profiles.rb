class CreateAttendantProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :attendant_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :registration_number , unique: true

      t.timestamps
    end
  end
end
