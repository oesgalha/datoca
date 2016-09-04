# == Schema Information
#
# Table name: competitions
#
#  id              :integer          not null, primary key
#  name            :string
#  max_team_size   :integer
#  evaluation_type :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Competition < ApplicationRecord
end
