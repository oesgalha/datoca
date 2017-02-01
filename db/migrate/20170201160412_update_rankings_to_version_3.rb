class UpdateRankingsToVersion3 < ActiveRecord::Migration
  def change
    update_view :rankings, version: 3, revert_to_version: 2, materialized: true
  end
end
