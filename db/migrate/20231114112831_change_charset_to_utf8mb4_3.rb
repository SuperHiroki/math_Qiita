class ChangeCharsetToUtf8mb43 < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
  end
end
