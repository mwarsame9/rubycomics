class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.belongs_to :user
      t.string :path
      t.timestamps
    end
  end
end
