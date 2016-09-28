class CompetitionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_competition, only: [:show, :edit, :update, :destroy]

  # GET /competitions
  def index
    @q = Competition.ransack(params[:q])
    @competitions = policy_scope(@q.result)
  end

  # GET /competitions/1
  def show
    authorize(@competition)
  end

  # GET /competitions/new
  def new
    @competition = Competition.new
    @competition.instructions.build([
      { name: 'Avaliação' },
      { name: 'Descrição' },
      { name: 'Regras' }
    ])
    authorize(@competition)
  end

  # GET /competitions/1/edit
  def edit
    authorize(@competition)
  end

  # POST /competitions
  def create
    @competition = Competition.new(competition_params)
    authorize(@competition)
    if @competition.save
      redirect_to @competition, notice: 'Competition was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /competitions/1
  def update
    authorize(@competition)
    if @competition.update(competition_params)
      redirect_to @competition, notice: 'Competition was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /competitions/1
  def destroy
    authorize(@competition)
    @competition.destroy
    redirect_to competitions_url, notice: 'Competition was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def competition_params
      params.require(:competition).permit(:name, :max_team_size, :evaluation_type, :expected_csv, :deadline, :ilustration, instructions_attributes: [:id, :name, :markdown, :_destroy, attachments_files: []])
    end
end
