class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email1
      t.string :email2
      t.string :email3
      t.string :email4
      t.string :email5
      t.string :email6
      t.boolean :like, default: false
      t.boolean :comment, default: false
      t.boolean :answer, default: false

      t.timestamps
    end
  end
end
