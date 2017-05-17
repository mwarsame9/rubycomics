class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.belongs_to :page
      t.string :name
      t.string :comment_text
      t.timestamps
    end
  end
end
