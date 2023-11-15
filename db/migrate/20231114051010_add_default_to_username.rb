class AddDefaultToUsername < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :username, from: nil, to: "default_username"
  end
end

