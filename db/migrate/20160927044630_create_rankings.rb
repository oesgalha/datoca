class CreateRankings < ActiveRecord::Migration
  def change
    create_view :rankings, materialized: true
  end
end
