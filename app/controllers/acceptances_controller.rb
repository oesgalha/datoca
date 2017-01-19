class AcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_competition

  def new
    if @competition.acceptances.exists?(user: current_user)
      redirect_to @competition
    else
      @acceptance = @competition.acceptances.build
      render 'competitions/show'
    end
  end

  def create
    if @competition.acceptances.exists?(user: current_user)
      redirect_to @competition
    else
      @competition.acceptances.create!(user: current_user)
      redirect_to data_path(session.delete(:download_uuid))
    end
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end
end
