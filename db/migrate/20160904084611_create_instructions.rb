class CreateInstructions < ActiveRecord::Migration[5.0]
  def change
    create_table :instructions do |t|
      t.string :name
      t.text :markdown
      t.text :html
      t.references :competition, foreign_key: true

      t.timestamps
    end
  end
end
