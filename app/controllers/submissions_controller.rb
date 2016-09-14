class SubmissionsController < ApplicationController
  before_action :set_competition
  before_action :set_competitor_opts, only: [:new, :create]

  def show
    @submission = Submission.with_rank.find(params[:id])
  end

  def new
    @submission = Submission.new
  end

  def create
    @submission = @competition.submissions.build(submission_params)
    if @submission.save
      redirect_to [@competition, @submission]
    else
      render :new
    end
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
