class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :public_email
      t.string :github
      t.string :website
      t.string :organization
      t.string :location
      t.text :introduction, limit: 200
      t.string :sns1
      t.string :sns2
      t.string :sns3
      t.string :sns4
      t.string :sns5
      t.string :sns6

      t.timestamps
    end
  end
end