class DropRepliesTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :replies
  end

  def down
    create_table :replies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
