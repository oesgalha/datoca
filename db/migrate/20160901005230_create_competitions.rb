class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.string :name
      t.integer :max_team_size
      t.integer :evaluation_type

      t.timestamps
    end
  end
end
