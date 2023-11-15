# app/controllers/likes_controller.rb
class LikesController < ApplicationController
    before_action :authenticate_user!, only: [:create, :destroy]
  
    def create
      @likeable = find_likeable
      current_user.likes.create!(likeable: @likeable)
      send_notification(@likeable) # メール通知を送る
      redirect_back(fallback_location: root_path, notice: "いいね！を追加しました。")
    end
  
    def destroy
      @like = current_user.likes.find(params[:id])
      @like.destroy
      redirect_back(fallback_location: root_path, notice: "いいね！を削除しました。")
    end
    
    def count
      @sort = params[:sort] || 'total_likes'
      @users = User.all
  
      # 各ユーザーの記事、質問、コメント、回答に対するいいね数を集計
      @likes_for_articles = Post.where(post_type: 'article').joins(:likes).group('posts.user_id').count
      @likes_for_questions = Post.where(post_type: 'question').joins(:likes).group('posts.user_id').count
      @likes_for_comments = Comment.joins(:post, :likes).where(posts: { post_type: 'article' }).group('comments.user_id').count
      @likes_for_answers = Comment.joins(:post, :likes).where(posts: { post_type: 'question' }).group('comments.user_id').count
  
      # 合計いいね数の計算
      @total_likes = @likes_for_articles.merge(@likes_for_questions) { |key, old_val, new_val| old_val + new_val }
      @total_likes.merge!(@likes_for_comments) { |key, old_val, new_val| old_val + new_val }
      @total_likes.merge!(@likes_for_answers) { |key, old_val, new_val| old_val + new_val }
  
      # ユーザーの並び替え
      @users = @users.sort_by do |user|
        case @sort
        when 'total_likes'
          -(@total_likes[user.id] || 0)
        when 'article_likes'
          -(@likes_for_articles[user.id] || 0)
        when 'question_likes'
          -(@likes_for_questions[user.id] || 0)
        when 'comment_likes'
          -(@likes_for_comments[user.id] || 0)
        when 'answer_likes'
          -(@likes_for_answers[user.id] || 0)
        else
          -(@total_likes[user.id] || 0)
        end
      end
    end
  
    private
  
    def find_likeable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
        end
      end
      nil
    end

    def send_notification(likeable)

      logger.debug "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
      recipient = likeable.user
      return if recipient == current_user # 自分自身の投稿には通知しない
  
      notification_setting = recipient.notification
      return unless notification_setting&.like # いいね通知が有効でなければ終了
      logger.debug "EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
      # 設定されているメールアドレスに通知を送る
      (1..6).each do |i|
        email = notification_setting.send("email#{i}")
        NotificationMailer.like_notification(email, likeable).deliver_later if email.present?
      end
    end

end