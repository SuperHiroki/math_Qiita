class CreateReplies < ActiveRecord::Migration[7.1]
  def change
    create_table :replies do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true # This post is a question.

      t.timestamps
    end
  end
end
