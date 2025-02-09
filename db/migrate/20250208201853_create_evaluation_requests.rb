class CreateEvaluationRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluation_requests do |t|
      t.references :attendant, null: false, foreign_key: { to_table: :users }
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.string :evaluation_token, null: false
      t.string :status, null: false, default: 'pending'
      t.timestamp :expires_at

      t.timestamps
      t.index :evaluation_token, unique: true
    end
  end
end
