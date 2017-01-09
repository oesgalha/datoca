class CreateAcceptances < ActiveRecord::Migration[5.0]
  def change
    create_table :acceptances do |t|
      t.references :competition, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
