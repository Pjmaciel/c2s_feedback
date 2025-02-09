class CreateEvaluations < ActiveRecord::Migration[7.1]
  def change
    create_table :evaluations do |t|
      t.references :attendant, null: false, foreign_key: { to_table: :users }
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.integer :score, null: false
      t.text :comment, null: false
      t.datetime :evaluation_date, null: false

      t.timestamps
    end

    add_index :evaluations, [:client_id, :attendant_id, :evaluation_date]
  end
end