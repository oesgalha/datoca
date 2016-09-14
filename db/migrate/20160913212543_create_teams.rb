class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.text :description
      t.has_attached_file :avatar

      t.timestamps
    end
    create_join_table :teams, :users do |t|
      t.index :user_id
      t.index :team_id
    end
  end
end
