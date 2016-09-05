# == Schema Information
#
# Table name: competitions
#
#  id                       :integer          not null, primary key
#  name                     :string
#  max_team_size            :integer
#  evaluation_type          :integer
#  total_prize              :decimal(9, 2)
#  deadline                 :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  ilustration_file_name    :string
#  ilustration_content_type :string
#  ilustration_file_size    :integer
#  ilustration_updated_at   :datetime
#

class Competition < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  has_attached_file :ilustration, styles: { regular: "128x128>" }

  # =================================
  # Associations
  # =================================

  has_many :instructions, inverse_of: :competition
  has_one :description,     -> { where name: 'Descrição' }, class_name: 'Instruction', inverse_of: :competition
  has_one :evaluation_text, -> { where name: 'Avaliação' }, class_name: 'Instruction', inverse_of: :competition
  has_one :rules,           -> { where name: 'Regras' },    class_name: 'Instruction', inverse_of: :competition

  accepts_nested_attributes_for :description
  accepts_nested_attributes_for :evaluation_text
  accepts_nested_attributes_for :rules

  # =================================
  # Validations
  # =================================

  validates :description, presence: true
  validates :evaluation_text, presence: true
  validates :rules, presence: true
  validates_attachment_content_type :ilustration, content_type: /\Aimage\/.*\z/

end
