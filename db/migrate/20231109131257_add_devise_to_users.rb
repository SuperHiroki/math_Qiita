class AddDeviseToUsers < ActiveRecord::Migration[7.1]
  def change
    # Deviseに必要なカラムを追加
    # すでにemailがある場合はこの行は不要です。
    # add_column :users, :email, :string, null: false, default: ""

    # password_digestをDeviseのencrypted_passwordに変更
    rename_column :users, :password_digest, :encrypted_password

    # Deviseのrecoverableモジュールに必要なカラムを追加
    add_column :users, :reset_password_token, :string
    add_column :users, :reset_password_sent_at, :datetime

    # Deviseのrememberableモジュールに必要なカラムを追加
    add_column :users, :remember_created_at, :datetime

    # Deviseがemailとreset_password_tokenのインデックスを要求するため、
    # データベースがユニーク制約を強制するインデックスを追加
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true

    # その他、Deviseが提供するモジュールを使用する場合は、
    # 必要なカラムをここに追加してください。
  end
end
