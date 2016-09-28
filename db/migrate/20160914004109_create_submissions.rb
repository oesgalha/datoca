class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.text :explanation_md
      t.text :explanation_html
      t.string :csv_id
      t.string :csv_filename
      t.string :csv_content_type
      t.integer :csv_size
      t.references :competition, foreign_key: true
      t.references :competitor, polymorphic: true, index: true
      t.decimal :evaluation_score, precision: 20, scale: 10

      t.timestamps
    end
  end
end
