class CreateSubmissions < ActiveRecord::Migration[5.0]
  def change
    create_table :submissions do |t|
      t.text :explanation_md
      t.text :explanation_html
      t.has_attached_file :csv
      t.references :competition, foreign_key: true
      t.references :competitor, polymorphic: true, index: true
      t.decimal :evaluation_score, precision: 11, scale: 10

      t.timestamps
    end
  end
end
