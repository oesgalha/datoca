# == Schema Information
#
# Table name: rankings
#
#  submission_id    :integer
#  competitor_id    :integer
#  competitor_type  :string
#  evaluation_score :decimal(20, 10)
#  competition_id   :integer
#  rank             :integer
#

class Ranking < ApplicationRecord

  # =================================
  # Associations
  # =================================

  belongs_to :submission
  belongs_to :competition
  belongs_to :competitor, polymorphic: true

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: false)
  end
end
