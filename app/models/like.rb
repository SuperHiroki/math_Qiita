class Like < ApplicationRecord
    belongs_to :user
    belongs_to :likeable, polymorphic: true
  
    # いいねはユーザーといいねされたオブジェクトの組み合わせが一意であることを保証します
    validates :user_id, uniqueness: { scope: [:likeable_type, :likeable_id] }
end