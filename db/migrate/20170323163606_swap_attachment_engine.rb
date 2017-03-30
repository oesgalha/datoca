class SwapAttachmentEngine < ActiveRecord::Migration[5.0]
  def change

    remove_column :attachments, :file_id, :string
    remove_column :attachments, :file_filename, :string
    remove_column :attachments, :file_content_type, :string
    remove_column :attachments, :file_size, :integer

    add_attachment :attachments, :file

    remove_column :competitions, :expected_csv_id, :string
    remove_column :competitions, :expected_csv_filename, :string
    remove_column :competitions, :expected_csv_content_type, :string
    remove_column :competitions, :expected_csv_size, :integer
    remove_column :competitions, :ilustration_id, :string
    remove_column :competitions, :ilustration_filename, :string
    remove_column :competitions, :ilustration_content_type, :string
    remove_column :competitions, :ilustration_size, :integer

    add_attachment :competitions, :expected_csv
    add_attachment :competitions, :ilustration

    remove_column :submissions, :csv_id, :string
    remove_column :submissions, :csv_filename, :string
    remove_column :submissions, :csv_content_type, :string
    remove_column :submissions, :csv_size, :integer

    add_attachment :submissions, :csv

    remove_column :teams, :avatar_id, :string
    remove_column :teams, :avatar_filename, :string
    remove_column :teams, :avatar_content_type, :string
    remove_column :teams, :avatar_size, :integer

    add_attachment :teams, :avatar

    remove_column :users, :avatar_id, :string
    remove_column :users, :avatar_filename, :string
    remove_column :users, :avatar_content_type, :string
    remove_column :users, :avatar_size, :integer

    add_attachment :users, :avatar
  end
end
