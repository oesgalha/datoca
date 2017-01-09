class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :set_collections, only: [:new, :edit, :create, :update]

  # GET /teams/1
  def show
    authorize(@team)
  end

  # GET /teams/new
  def new
    authorize(@team = Team.new)
  end

  # GET /teams/1/edit
  def edit
    authorize(@team)
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    authorize(@team)
    if @team.save
      redirect_to @team, notice: 'Equipe criada com sucesso.'
    else
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    authorize(@team)
    if @team.update(team_params)
      redirect_to @team, notice: 'Equipe atualizada com sucesso.'
    else
      render :edit
    end
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def set_collections
    @users = User.where.not(id: current_user)
  end

  def team_params
    params.require(:team).permit(:name, :description, :avatar, { user_ids: [] }).tap do |tp|
      tp[:user_ids] << current_user.id
      tp[:user_ids].concat(@team.user_ids) if @team&.user_ids
    end
  end
end
