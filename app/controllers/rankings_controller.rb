class RankingsController < ApplicationController
  before_action :set_competition

  def index
    @rankings = policy_scope(@competition.rankings.order(:rank))
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end
end
