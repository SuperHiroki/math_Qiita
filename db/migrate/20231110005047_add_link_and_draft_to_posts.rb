class AddLinkAndDraftToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :link, :string
    add_column :posts, :draft, :boolean, default: false
  end
end
