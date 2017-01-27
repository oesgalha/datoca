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
  validate :validate_csv_size, :validate_csv_cols, :validate_csv_ids

  # =================================
  # Callbacks
  # =================================

  before_save :process_markdown, :set_score
  after_create ->{ Ranking.refresh }

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

  def read_csv
    @read_csv ||= CSV.new(csv.read, headers: true, converters: :numeric, header_converters: :symbol).read
  end

  def validate_csv_size
    unless read_csv.size + 1 == competition.expected_csv_line_count
      errors.add(:csv, "não contém o mesmo número de linhas da solução esperada!")
    end
  end

  def validate_csv_cols
    unless (read_csv.headers - headers.values).empty?
      errors.add(:csv, "deve ter apenas as seguintes colunas: \"#{competition.expected_csv_id_column}\" e \"#{competition.expected_csv_val_column}\"")
    end
  end

  def validate_csv_ids
    @metric_calc = Metrorb::Calculate.from_csvs(competition.expected_csv.read, csv.read, headers)
  rescue Metrorb::BadCsvError => e
    errors.add(:csv, "a sua solução também deve conter os seguintes ids: #{e.ids.join(',')}")
  end

  def clean_header(str)
    str.encode(Encoding.find('UTF-8')).downcase.strip.gsub(/\s+/, '_').gsub(/\W+/, '').to_sym
  end

  def headers
    {
      id: clean_header(competition.expected_csv_id_column),
      value: clean_header(competition.expected_csv_val_column),
    }
  end

  # TODO: Move to background
  def set_score
    case competition.evaluation_type
    when 'mae'
      self.evaluation_score = @metric_calc.mae
    end
  end

  # TODO: Move to background
  def process_markdown
    self.explanation_html = Kramdown::Document.new(explanation_md || '').to_html.gsub(/[\r\n]+/, '')
  end
end
