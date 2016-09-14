# == Schema Information
#
# Table name: submissions
#
#  id               :integer          not null, primary key
#  explanation_md   :text
#  explanation_html :text
#  csv_file_name    :string
#  csv_content_type :string
#  csv_file_size    :integer
#  csv_updated_at   :datetime
#  competition_id   :integer
#  competitor_type  :string
#  competitor_id    :integer
#  evaluation_score :decimal(11, 10)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_submissions_on_competition_id                     (competition_id)
#  index_submissions_on_competitor_type_and_competitor_id  (competitor_type,competitor_id)
#
# Foreign Keys
#
#  fk_rails_496d2f3eb9  (competition_id => competitions.id)
#

class Submission < ApplicationRecord

  # =================================
  # Plugins
  # =================================
  has_attached_file :csv

  # =================================
  # Associations
  # =================================

  belongs_to :competition
  belongs_to :competitor, polymorphic: true

  # =================================
  # Validations
  # =================================

  validates :competitor, presence: true
  validates :csv, presence: true
  validates_attachment_file_name :csv, matches: /\.csv\Z/
  validates_attachment_content_type :csv, content_type: %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )

  # =================================
  # Callbacks
  # =================================

  before_save :process_markdown, :set_score

  # =================================
  # Class Methods
  # =================================

  def self.with_rank
    ranked(:evaluation_score)
  end

  # =================================
  # Instance Methods
  # =================================

  def competitor_sgid
    competitor&.to_sgid_param
  end

  def competitor_sgid=(sgid)
    self.competitor = GlobalID::Locator.locate_signed(sgid)
  end

  def number
    @number ||= competition.submissions.order(:created_at).pluck(:id).index(id) + 1
  end

  def competitor_attempt
    @number ||= competitor.submissions.order(:created_at).pluck(:id).index(id) + 1
  end

  private

  def set_score
    self.evaluation_score = rand
  end

  # TODO: Move to background
  def process_markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true).tap do |renderer|
      self.explanation_html = renderer.render(explanation_md || '').gsub(/[\r\n]+/, '')
    end
  end
end
