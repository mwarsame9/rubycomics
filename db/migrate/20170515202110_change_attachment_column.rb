require 'paperclip'
include Paperclip::Schema
class ChangeAttachmentColumn < ActiveRecord::Migration[5.1]
  def up
    remove_column :pages, :path
    add_attachment :pages, :page_img
  end

  def down
    add_column :pages, :path, :string
    remove_attachment :pages, :page_img
  end
end
