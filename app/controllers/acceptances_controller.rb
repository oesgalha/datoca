class AcceptancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_competition

  def new
    @acceptance = @competition.acceptances.build
    render 'competitions/show'
  end

  def create
    @acceptance = @competition.acceptances.build(user: current_user)
    if @competition.save
      flash[:notice] = 'Agora você pode baixar os arquivos da competição'
    end
    render 'competitions/show'
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end
end
