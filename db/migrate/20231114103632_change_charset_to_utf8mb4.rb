class ChangeCharsetToUtf8mb4 < ActiveRecord::Migration[7.1]
  def change
    # 例として、users テーブルの文字セットを変更する
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"
    # 他のテーブルに対しても同様の操作を繰り返す
  end
end
