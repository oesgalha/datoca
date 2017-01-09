class UpdateRankingsToVersion2 < ActiveRecord::Migration
  def change
    update_view :rankings, version: 2, revert_to_version: 1, materialized: true
  end
end
