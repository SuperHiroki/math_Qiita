class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :post_type, default: 'article' # 'article' or 'question'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end