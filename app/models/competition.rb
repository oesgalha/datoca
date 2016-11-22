# == Schema Information
#
# Table name: competitions
#
#  id                        :integer          not null, primary key
#  name                      :string
#  max_team_size             :integer
#  evaluation_type           :integer          default("mae")
#  daily_attempts            :integer          default(3)
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
#  expected_csv_id_column    :string           default("id")
#  expected_csv_val_column   :string           default("value")
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Competition < ApplicationRecord

  # =================================
  # Constants
  # =================================

  REQUIRED_INSTRUCTIONS = ['Avaliação', 'Dados', 'Descrição', 'Regras']

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

  # =================================
  # Class Methods
  # =================================

  def self.new_with_instructions
    self.new.tap do |c|
      c.instructions.build(REQUIRED_INSTRUCTIONS.map { |name| { name: name} })
    end
  end

  # =================================
  # Instance Methods
  # =================================

  def has_required_instructions
    unless (REQUIRED_INSTRUCTIONS & instructions.map(&:name)).size == REQUIRED_INSTRUCTIONS.size
      errors.add(:instructions, "precisa conter pelo menos as seguintes instruções: " + REQUIRED_INSTRUCTIONS.join(', '))
    end
  end

  def files_can_be_downloaded_by?(user)
    acceptances.where(user: user).any?
  end
end
