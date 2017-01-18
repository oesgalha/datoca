class AddUuidToAttachments < ActiveRecord::Migration[5.0]
  def change
    add_column :attachments, :uuid, :string
  end
end
