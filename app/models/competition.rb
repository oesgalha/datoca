# == Schema Information
#
# Table name: competitions
#
#  id                        :integer          not null, primary key
#  name                      :string
#  max_team_size             :integer
#  evaluation_type           :integer          default("mae")
#  total_prize               :decimal(9, 2)
#  deadline                  :datetime
#  ilustration_id            :string
#  ilustration_filename      :string
#  ilustration_content_type  :string
#  ilustration_size          :integer
#  expected_csv_id           :string
#  expected_csv_filename     :string
#  expected_csv_content_type :string
#  expected_csv_size         :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Competition < ApplicationRecord

  # =================================
  # Constants
  # =================================

  enum evaluation_type: {
    mae: 0,                     # Mean Absolute Error
  }

  # =================================
  # Plugins
  # =================================

  attachment :expected_csv, type: :csv, extension: 'csv'
  attachment :ilustration, type: :image

  # =================================
  # Associations
  # =================================

  has_many :rankings
  has_many :submissions
  has_many :acceptances
  has_many :users, -> { order(:created_at).distinct }, through: :submissions, source: :competitor, source_type: 'User'
  has_many :teams, -> { order(:created_at).distinct }, through: :submissions, source: :competitor, source_type: 'Team'
  has_many :instructions, inverse_of: :competition, dependent: :destroy
  has_one :description,     -> { where name: 'Descrição' }, class_name: 'Instruction', inverse_of: :competition
  has_one :evaluation_text, -> { where name: 'Avaliação' }, class_name: 'Instruction', inverse_of: :competition

  accepts_nested_attributes_for :instructions
  accepts_nested_attributes_for :description
  accepts_nested_attributes_for :evaluation_text

  # =================================
  # Validations
  # =================================

  validates :name, presence: true
  validate :has_required_instructions
  validates :expected_csv, presence: true

  def has_required_instructions
    required_instructions = ['Descrição', 'Avaliação', 'Regras', 'Dados']
    unless (required_instructions & instructions.map(&:name)).size == required_instructions.size
      errors.add(:instructions, "precisa pelo menos conter as seguintes instruções: " + required_instructions.join(', '))
    end
  end

  def files_can_be_downloaded_by?(user)
    acceptances.where(user: user).any?
  end
end
