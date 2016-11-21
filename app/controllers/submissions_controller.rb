class SubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_competition
  before_action :set_competitor_opts, only: [:new, :create]

  def index
    @submissions = policy_scope(@competition.submissions.order(:evaluation_score).includes(:competitor))
  end

  def show
    @submission = @competition.submissions.with_rank.find(params[:id])
  end

  def new
    authorize(@submission = Submission.new(competition: @competition))
  end

  def summary
    scope = @competition.submissions.includes(:competitor)
    @submissions = scope.where(competitor: current_user).or(scope.where(competitor: current_user.teams))
    @rank = Ranking.where(submission: @submissions).first
  end

  def create
    @submission = @competition.submissions.build(submission_params)
    authorize(@submission)
    if @submission.save
      redirect_to summary_competition_submissions_path(@competition)
    else
      render :new
    end
  end

  def destroy
    authorize(@submission = @competition.submissions.find(params[:id]))
    @submission.destroy
    redirect_to competition_submissions_path(@competition), notice: 'Competição apagada com sucesso.'
  end

  private

  def set_competition
    @competition = Competition.find(params[:competition_id])
  end

  def set_competitor_opts
    @user_options = [['Eu', current_user.to_sgid_param]]
    @team_options = [['Times', current_user.teams.map { |team| [team.name, team.to_sgid_param] }]]
  end

  def submission_params
    params.require(:submission).permit(:csv, :explanation_md, :competitor_sgid)
  end
end
