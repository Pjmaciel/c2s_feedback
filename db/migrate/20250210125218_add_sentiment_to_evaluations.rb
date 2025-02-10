class AddSentimentToEvaluations < ActiveRecord::Migration[7.1]
  def change
    add_column :evaluations, :sentiment, :string
    add_index :evaluations, :sentiment
  end
end