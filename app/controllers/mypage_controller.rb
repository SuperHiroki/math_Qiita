class MypageController < ApplicationController
    before_action :set_target_user

    def articles
      @posts = @target_user.posts.where(post_type: 'article')
      logger.debug "BBBBBBBBBBBBBBBBBBBBBBBBB #{@target_user.username}"
    end
  
    def comments
      @posts = Post.joins(:comments)
                    .where(comments: { user_id: @target_user.id })
                    .where(post_type: 'article')
                    .order('posts.created_at DESC')
                    .distinct
    end
  
    def questions
      @posts = @target_user.posts.where(post_type: 'question')
    end
  
    def answers
      @posts = Post.joins(:comments)
                    .where(comments: { user_id: @target_user.id })
                    .where(post_type: 'question')
                    .order('posts.created_at DESC')
                    .distinct
    end

    def likes_articles
      liked_article_ids = @target_user.likes.where(likeable_type: 'Post').pluck(:likeable_id)
      @posts = Post.where(id: liked_article_ids, post_type: 'article').order(created_at: :desc)
    end
    
    def likes_questions
      liked_question_ids = @target_user.likes.where(likeable_type: 'Post').pluck(:likeable_id)
      @posts = Post.where(id: liked_question_ids, post_type: 'question').order(created_at: :desc)
    end

    def likes_comments
      liked_comment_ids = @target_user.likes.where(likeable_type: 'Comment').pluck(:likeable_id)
      comment_posts_ids = Comment.where(id: liked_comment_ids).pluck(:post_id).uniq
      @posts = Post.where(id: comment_posts_ids, post_type: 'article').order(created_at: :desc)
    end

    def likes_answers
      liked_comment_ids = @target_user.likes.where(likeable_type: 'Comment').pluck(:likeable_id)
      answer_posts_ids = Comment.where(id: liked_comment_ids).pluck(:post_id).uniq
      @posts = Post.where(id: answer_posts_ids, post_type: 'question').order(created_at: :desc)
    end

    def profile
      @profile = @target_user.profile || @target_user.build_profile
      logger.debug "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV #{@profile.public_email}"
    end
  
    private
  
    def set_target_user
      @target_user = User.find_by!(username: params[:username])
    end
end
  