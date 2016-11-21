class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.integer :max_team_size
      t.integer :evaluation_type, default: 0
      t.decimal :total_prize, precision: 9, scale: 2
      t.datetime :deadline
      t.string :ilustration_id
      t.string :ilustration_filename
      t.string :ilustration_content_type
      t.integer :ilustration_size
      t.string :expected_csv_id
      t.string :expected_csv_filename
      t.string :expected_csv_content_type
      t.integer :expected_csv_size
      t.string :expected_csv_id_column, default: 'id'
      t.string :expected_csv_val_column, default: 'value'

      t.timestamps
    end
  end
end
