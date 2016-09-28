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
  has_many :attachments, dependent: :destroy

  accepts_attachments_for :attachments

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
    attachments.each do |att|
      # ~ magic regex ~
      self.markdown = self.markdown.sub(/\[.+?\]\(.+?\/#{att.file.id}\/.+?\)/) do |md_str|
        att.file_attacher.store!
        "[#{att.file_filename}](#{att.file_url})"
      end
    end
    self.html = Kramdown::Document.new(self.markdown || '').to_html.gsub(/[\r\n]+/, '')
  end

  def text
    html || markdown
  end
end
