class AttachmentPolicy < ApplicationPolicy

  # =================================
  # Actions
  # =================================

  def show?
    competition.files_can_be_downloaded_by?(user)
  end

  private

  def competition
    record.competition
  end
end
