# == Schema Information
#
# Table name: teams
#
#  id                  :integer          not null, primary key
#  name                :string
#  description         :text
#  avatar_id           :string
#  avatar_filename     :string
#  avatar_content_type :string
#  avatar_size         :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Team < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  attachment :avatar, type: :image

  # =================================
  # Associations
  # =================================

  has_many :rankings, as: :competitor
  has_many :submissions, as: :competitor
  has_many :competitions, -> { order(:created_at).distinct }, through: :submissions
  has_and_belongs_to_many :users

  # =================================
  # Validations
  # =================================

  validates :name, presence: true
  validates :description, length: { maximum: 256 }, allow_blank: true
end
