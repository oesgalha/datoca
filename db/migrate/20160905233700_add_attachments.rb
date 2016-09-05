class AddAttachments < ActiveRecord::Migration[5.0]
  def up
    add_attachment :users, :avatar
    add_attachment :competitions, :ilustration
  end

  def down
    remove_attachment :users, :avatar
    remove_attachment :competitions, :ilustration
  end
end
