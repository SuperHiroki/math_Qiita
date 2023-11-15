class ChangeCharsetToUtf8mb42 < ActiveRecord::Migration[7.1]
  def up
    execute "ALTER TABLE comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE likes CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE notifications CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE post_tags CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE posts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE profiles CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    execute "ALTER TABLE tags CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"

    # usersテーブルはすでに変更済みのため、ここには含めない
  end

  def down
    execute "ALTER TABLE comments CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE likes CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE notifications CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE post_tags CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE posts CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE profiles CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"
    execute "ALTER TABLE tags CONVERT TO CHARACTER SET latin1 COLLATE latin1_swedish_ci"

    # usersテーブルはすでに変更済みのため、ここには含めない
  end
end
