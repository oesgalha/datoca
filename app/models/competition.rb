# == Schema Information
#
# Table name: competitions
#
#  id                        :integer          not null, primary key
#  name                      :string
#  max_team_size             :integer
#  evaluation_type           :integer
#  total_prize               :decimal(9, 2)
#  deadline                  :datetime
#  ilustration_file_name     :string
#  ilustration_content_type  :string
#  ilustration_file_size     :integer
#  ilustration_updated_at    :datetime
#  expected_csv_file_name    :string
#  expected_csv_content_type :string
#  expected_csv_file_size    :integer
#  expected_csv_updated_at   :datetime
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class Competition < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  has_attached_file :expected_csv
  has_attached_file :ilustration, styles: { regular: "128x128>" }

  # =================================
  # Associations
  # =================================

  has_many :submissions
  has_many :users, -> { order(:created_at).distinct }, through: :submissions, source: :competitor, source_type: 'User'
  has_many :teams, -> { order(:created_at).distinct }, through: :submissions, source: :competitor, source_type: 'Team'
  has_many :instructions, inverse_of: :competition
  has_one :description,     -> { where name: 'Descrição' }, class_name: 'Instruction', inverse_of: :competition
  has_one :evaluation_text, -> { where name: 'Avaliação' }, class_name: 'Instruction', inverse_of: :competition
  has_one :rules,           -> { where name: 'Regras' },    class_name: 'Instruction', inverse_of: :competition

  accepts_nested_attributes_for :instructions
  accepts_nested_attributes_for :description
  accepts_nested_attributes_for :evaluation_text
  accepts_nested_attributes_for :rules

  # =================================
  # Validations
  # =================================

  validates :description, presence: true
  validates :evaluation_text, presence: true
  validates :rules, presence: true
  validates :expected_csv, presence: true
  validates_attachment_file_name :expected_csv, matches: /\.csv\Z/
  validates_attachment_content_type :expected_csv, content_type: %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )
  validates_attachment_content_type :ilustration, content_type: /\Aimage\/.*\z/

end
