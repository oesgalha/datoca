# == Schema Information
#
# Table name: acceptances
#
#  id             :integer          not null, primary key
#  competition_id :integer
#  user_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_acceptances_on_competition_id  (competition_id)
#  index_acceptances_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_779372ecdf  (competition_id => competitions.id)
#  fk_rails_b2993b2740  (user_id => users.id)
#

class Acceptance < ApplicationRecord

  # =================================
  # Associations
  # =================================

  belongs_to :user
  belongs_to :competition

end
