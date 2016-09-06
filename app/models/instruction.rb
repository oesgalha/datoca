# == Schema Information
#
# Table name: instructions
#
#  id             :integer          not null, primary key
#  name           :string
#  markdown       :text
#  html           :text
#  competition_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_instructions_on_competition_id  (competition_id)
#
# Foreign Keys
#
#  fk_rails_12c732421b  (competition_id => competitions.id)
#

class Instruction < ApplicationRecord

  # =================================
  # Associations
  # =================================

  belongs_to :competition, inverse_of: :instructions

  # =================================
  # Validations
  # =================================

  validates :name, presence: true, uniqueness: { scope: :competition_id }
  validates :markdown, presence: true

  # =================================
  # Callbacks
  # =================================

  before_save :process_markdown, if: :markdown_changed?

  # TODO: Move to background
  def process_markdown
    md_renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    self.html = md_renderer.render(self.markdown).gsub(/[\r\n]+/, '')
  end

  def text
    html || markdown
  end
end
