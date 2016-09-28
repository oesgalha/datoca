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

  attachment :file

  # =================================
  # Associations
  # =================================

  belongs_to :competition, inverse_of: :instructions

end
