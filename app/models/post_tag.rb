class PostTag < ApplicationRecord
    belongs_to :post
    belongs_to :tag
  
    # 同じ投稿に同じタグが複数回割り当てられないようにします
    validates :post_id, uniqueness: { scope: :tag_id }
end
  