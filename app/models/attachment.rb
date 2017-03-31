# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  instruction_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  uuid              :string
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#
# Indexes
#
#  index_attachments_on_instruction_id  (instruction_id)
#
# Foreign Keys
#
#  fk_rails_8976efffe2  (instruction_id => instructions.id)
#

class Attachment < ApplicationRecord

  # Images + CSV
  IMG_CONTENT_TYPES = %w( image/jpeg image/gif image/png )
  CSV_CONTENT_TYPES = %w( text/plain text/comma-separated-values text/csv application/csv application/excel application/vnd.ms-excel application/vnd.msexcel )
  ATTACHMENT_CONTENT_TYPES = IMG_CONTENT_TYPES + CSV_CONTENT_TYPES
  ATTACHMENT_EXTENSIONS = [/csv\z/, /gif\z/, /png\z/, /jpe?g\z/]

  # =================================
  # Plugins
  # =================================

  has_attached_file :file,
  {
    path: "content/:hash.:extension",
    url: "content/:hash.:extension",
    # Magic Number Explanation:
    # (1344 / 12) * 9 = 1008
    # Bulma (css framework) max width on fullhd is 1344
    # The competition main screen is divided in 12 columns,
    # the text/images area have 9 columns width
    # So we don't need images with more than 1008 pixels of width
    styles: { max: '1008x>' },
    hash_secret: Datoca.config.dig('attachments', 'attachments', 'file', 'secret'),
    hash_digest: Datoca.config.dig('attachments', 'attachments', 'file', 'digest')
  }

  # =================================
  # Associations
  # =================================

  has_one :competition, through: :instruction
  belongs_to :instruction, inverse_of: :attachments
  validates :file, {
    attachment_content_type: { content_type: ATTACHMENT_CONTENT_TYPES },
    attachment_file_name: { matches: ATTACHMENT_EXTENSIONS }
  }

  # =================================
  # Callbacks
  # =================================

  after_initialize :generate_uuid, unless: :uuid?
  before_post_process :skip_csv

  def is_csv?
    CSV_CONTENT_TYPES.include?(file_content_type)
  end

  def permanent_url
    Datoca::Application.routes.url_helpers.data_path(uuid)
  end

  private

  def skip_csv
    not is_csv?
  end

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
