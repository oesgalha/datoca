# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  file_id           :string
#  file_filename     :string
#  file_content_type :string
#  file_size         :integer
#  instruction_id    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  uuid              :string
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

  # =================================
  # Plugins
  # =================================

  attachment :file, store: 'instructions'

  # =================================
  # Associations
  # =================================

  has_one :competition, through: :instruction
  belongs_to :instruction, inverse_of: :attachments

  # =================================
  # Callbacks
  # =================================

  after_initialize :generate_uuid

  def is_csv?
    Refile.types[:csv].content_type.include?(file_content_type)
  end

  def permanent_url
    Datoca::Application.routes.url_helpers.data_path(uuid)
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end
