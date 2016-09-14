# == Schema Information
#
# Table name: teams
#
#  id                  :integer          not null, primary key
#  name                :string
#  description         :text
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Team < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  has_attached_file :avatar, styles: { medium: "256x256>", thumb: "96x96>" }

  # =================================
  # Associations
  # =================================

  has_and_belongs_to_many :users

  # =================================
  # Validations
  # =================================

  validates :name, presence: true
  validates :description, length: { maximum: 256 }, allow_blank: true
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  # =================================

  def image(style=:medium)
    if avatar.exists?
      avatar.url(style)
    else
      "https://identicons.github.com/#{Digest::MD5.hexdigest(name)}.png"
    end
  end
end
