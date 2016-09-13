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
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, styles: { medium: "256x256>", thumb: "96x96" }

  # =================================
  # Validations
  # =================================

  validates :bio, length: { maximum: 256 }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

end
