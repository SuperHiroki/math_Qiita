# app/models/post.rb
class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :likes, as: :likeable, dependent: :destroy
    has_many :post_tags, dependent: :destroy
    has_many :tags, through: :post_tags
  
    validates :title, presence: true
    validates :content, presence: true
    validates :post_type, inclusion: { in: ['article', 'question'] }
    validates :link, presence: true
    validates :draft, inclusion: { in: [true, false] }

    before_validation :set_link, on: :create

    # 並び替えのスコープを定義する
    scope :filter_sort, -> (sort_param) {
      case sort_param
      when 'created_at_desc'
        order(created_at: :desc)
      when 'updated_at_desc'
        order(updated_at: :desc)
      when 'likes_count_desc'
        left_joins(:likes).group(:id).order('COUNT(likes.id) DESC')
      when 'comments_count_desc'
        left_joins(:comments).group(:id).order('COUNT(comments.id) DESC')
      else
        order(created_at: :desc)
      end
    }

    def self.ransackable_attributes(auth_object = nil)
      %w[title content]
    end
  
    # どの関連を検索可能にするかを定義
    def self.ransackable_associations(auth_object = nil)
      %w[tags user]
    end

    private

    def set_link
      if self.link.blank?
        self.link = "#{SecureRandom.uuid}"
        logger.debug("Link set to #{self.link}")
      end
    end
end