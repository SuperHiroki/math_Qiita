class AddDetailsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :icon_photo_name, :string, default: 'default.png', null: false
    add_column :users, :language, :string, default: 'Japanese', null: false
  end
end

