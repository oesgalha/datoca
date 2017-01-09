class CreateAttachments < ActiveRecord::Migration[5.0]
  def change
    create_table :attachments do |t|

      t.string :file_id
      t.string :file_filename
      t.string :file_content_type
      t.integer :file_size
      t.references :instruction, foreign_key: true
      t.timestamps
    end
  end
end
