class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.string :avatar_id
      t.string :avatar_filename
      t.string :avatar_content_type
      t.integer :avatar_size

      t.timestamps
    end
    create_join_table :teams, :users do |t|
      t.index :user_id
      t.index :team_id
    end
  end
end
