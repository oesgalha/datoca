# == Schema Information
#
# Table name: teams
#
#  id                  :integer          not null, primary key
#  name                :string
#  description         :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

class Team < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  has_attached_file :avatar,
  {
    path: "teams/avatars/:hash.:extension",
    url: "teams/avatars/:hash.:extension",
    styles: { big: '128x128#', med: '64x64#', min: '32x32#' },
    hash_secret: Datoca.config.dig('attachments', 'teams', 'avatar', 'secret'),
    hash_digest: Datoca.config.dig('attachments', 'teams', 'avatar', 'digest'),
    default_url: 'fallback-team.svg'
  }

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
  validates :avatar, {
    attachment_content_type: { content_type: ['image/jpeg', 'image/gif', 'image/png'] },
    attachment_file_name: { matches: [/gif\z/, /png\z/, /jpe?g\z/] }
  }
end
