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
  has_many :attachments, inverse_of: :instruction, dependent: :destroy

  accepts_attachments_for :attachments

  # =================================
  # Scopes
  # =================================
  scope :data, -> { where(name: 'Dados').first }
  scope :rules, -> { where(name: 'Regras').first }

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
      # ---------------------------------------------------------------
      # Change the temp attachment url for the permanent one
      #
      # 1. Look for the cache attachment url:
      #
      # ex: [file.csv](/attachments/A_HASH/cache/ANOTHER_HASH/file.csv)
      #
      # 2. Store the attachment in the permanent store
      # 3. Swap the cache url with the permanent url
      # ---------------------------------------------------------------
      self.markdown = self.markdown.sub(/\[.+?\]\(.+?\/#{att.file.id}\/.+?\)/) do |md_str|
        att.file_attacher.store!
        "[#{att.file_filename}](#{att.permanent_url})"
      end
    end
    self.html = Kramdown::Document.new(self.markdown || '').to_html.gsub(/[\r\n]+/, '')
  end

  def text
    html
  end
end
