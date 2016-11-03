# == Schema Information
#
# Table name: submissions
#
#  id               :integer          not null, primary key
#  explanation_md   :text
#  explanation_html :text
#  csv_id           :string
#  csv_filename     :string
#  csv_content_type :string
#  csv_size         :integer
#  competition_id   :integer
#  competitor_type  :string
#  competitor_id    :integer
#  evaluation_score :decimal(20, 10)
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

  MAX_DAILY_ATTEMPTS = 3

  # =================================
  # Plugins
  # =================================
  attachment :csv, type: :csv, extension: 'csv'

  # =================================
  # Associations
  # =================================

  has_one :ranking
  belongs_to :competition
  belongs_to :competitor, polymorphic: true

  # =================================
  # Validations
  # =================================

  validates :competitor, presence: true
  validates :csv, presence: true
  validate :validate_csv_size

  # =================================
  # Callbacks
  # =================================

  before_save :process_markdown, :set_score

  after_create do
    Ranking.refresh
  end

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
    @competitor_attempt ||= competitor.submissions.where(competition: competition).order(:created_at).pluck(:id).index(id) + 1
  end

  private

  def validate_csv_size
    unless csv.read.size == competition.expected_csv.read.size
      errors.add(:csv, "não contem o mesmo número de linhas da solução esperada!")
    end
  end

  # TODO: Move to background
  def set_score
    case competition.evaluation_type
    when 'mae'
      d1 = CSV.new(competition.expected_csv.read).read.transpose
      d2 = CSV.new(csv.read).read.transpose
      df1 = Daru::DataFrame.new(extract_cols(d1), order: [:id, :value])
      df2 = Daru::DataFrame.new(extract_cols(d2), order: [:id, :value])
      means = df1.join(df2, on: [:id], how: :inner).vector_by_calculation { (value_1 - value_2).abs }
      self.evaluation_score = (means.sum.to_d / means.size.to_d)
    end
  end

  def extract_cols(cols)
    id_col = cols.select { |col| col.first == competition.expected_csv_id_column }.first.tap { |col| col.shift; col }
    val_col = cols.select { |col| col.first == competition.expected_csv_val_column }.first.tap { |col| col.shift; col }
    [id_col.map(&:to_d), val_col.map(&:to_d)]
  end

  # TODO: Move to background
  def process_markdown
    self.explanation_html = Kramdown::Document.new(explanation_md || '').to_html.gsub(/[\r\n]+/, '')
  end
end
