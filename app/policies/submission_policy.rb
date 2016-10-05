class SubmissionPolicy < ApplicationPolicy

  # =================================
  # Scope
  # =================================

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(competitor: user)
      end
    end
  end

  # =================================
  # Actions
  # =================================

  # Should allow to attempt a submission if has not submitted
  # more than MAX_DAILY_ATTEMPTS in the last day
  # Allow a user to submit ONLY as an individual or through a single team
  # - The user cannot send as a team and an individual
  # - The user cannot be in more than one participating team
  def new?
    if individually_submitted?
      attempts_check(user)
    elsif team_submitted?
      attempts_check(submitter_team)
    else
      true
    end
  end

  def create?
    if individually_submitted?
      attempts_check(user) && record.competitor == user
    elsif team_submitted?
      attempts_check(submitter_team) && record.competitor == submitter_team
    else
      competitor.is_a?(User) || team_size_valid?
    end
  end

  private

  def team_size_valid?
    competition.max_team_size.nil? || competitor.users.size <= competition.max_team_size
  end

  def attempts_check(competitor)
    competition.submissions.where(competitor: competitor, created_at: today_range).size < Submission::MAX_DAILY_ATTEMPTS
  end

  def individually_submitted?
    user.individual_competitions.exists?(competition.id)
  end

  def team_submitted?
    user.team_competitions.exists?(competition.id)
  end

  # If the user already made a submission to the competition through a team
  # this method returns the aforementioned team.
  # It spits a nil otherwise
  def submitter_team
    @submitter_team ||= competition.teams.joins(:users).where({ users: { id: user.id } }).first
  end

  def today_range
    day_begin = Time.now.midnight
    day_end = (Time.now + 1.day).midnight - 1.second
    (day_begin..day_end)
  end

  def competitor
    record.competitor
  end

  def competition
    record.competition
  end
end
