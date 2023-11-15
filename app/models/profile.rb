# app/models/profile.rb
class Profile < ApplicationRecord
    belongs_to :user
  
    validates :introduction, length: { maximum: 200 }
end