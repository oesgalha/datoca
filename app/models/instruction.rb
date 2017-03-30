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

  accepts_nested_attributes_for :attachments

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
  # TODO: Currently swaping by the filename. This is weak, make it better.
  def process_markdown
    attachments.each do |att|
      # ---------------------------------------------------------------
      # Change the local blob url for the permanent one
      #
      # 1. Look for the file url:
      #
      # ex: [file.csv](whatever)
      #
      # 2. Swap the local blob url with the permanent url
      # ---------------------------------------------------------------
      self.markdown = self.markdown.sub(/\[#{att.file_file_name}\]\(.+?\)/) do |md_str|
        att.save!
        if att.is_csv?
          "[#{att.file_file_name}](#{att.permanent_url})"
        else
          "[#{att.file_file_name}](#{att.file.url(:max)})"
        end
      end
    end
    self.html = Kramdown::Document.new(self.markdown || '').to_html.gsub(/[\r\n]+/, '')
  end

  # Glue between multiple files field in the competition form and
  # accepts_nested_attributes_for :attachments
  # Clear the list and rebuild
  def attachments_files=(files)
    self.attachments = []
    files.each { |file| attachments.build(file: file) }
  end

  def text
    html
  end
end
