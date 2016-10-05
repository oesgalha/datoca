# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  name                   :string
#  handle                 :string
#  bio                    :text
#  location               :string
#  company                :string
#  avatar_id              :string
#  avatar_filename        :string
#  avatar_content_type    :string
#  avatar_size            :integer
#  role                   :integer          default("user")
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord

  # =================================
  # Constants
  # =================================

  enum role: { user: 0, admin: 1 }

  # =================================
  # Plugins
  # =================================
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  attachment :avatar, type: :image

  # =================================
  # Associations
  # =================================

  has_many :acceptances
  has_many :rankings, as: :competitor
  has_many :submissions, as: :competitor
  has_many :individual_competitions, -> { order(:created_at).distinct }, through: :submissions, source: :competition
  has_many :team_competitions, through: :teams, source: :competitions
  has_and_belongs_to_many :teams

  # =================================
  # Validations
  # =================================

  validates :bio, length: { maximum: 256 }, allow_blank: true
  validates :name, presence: true
end
