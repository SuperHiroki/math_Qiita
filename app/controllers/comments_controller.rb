# app/controllers/comments_controller.rb
class CommentsController < ApplicationController
    before_action :authenticate_user!
  
    def create
      @post = Post.find(params[:post_id])
      @comment = @post.comments.build(comment_params.merge(user: current_user))
      if @comment.save
        send_notification(@comment) # コメントに対する通知を送る
        redirect_to request.referer, notice: "Comment added successfully."
      else
        redirect_to request.referer, alert: "Failed to add comment."
      end
    end

    def destroy
      comment = Comment.find(params[:id])
      comment.destroy if comment.user == current_user || @post.user == current_user
      redirect_back(fallback_location: root_path, notice: "コメントを削除しました。")
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:body)
    end

    def send_notification(comment)
      logger.debug "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
      # コメントの投稿者が記事の著者と同じであれば通知しない
      return if comment.post.user == current_user

      recipient = comment.post.user
      notification_setting = recipient.notification
      return unless notification_setting&.comment # コメント通知が有効でなければ終了
      logger.debug "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC"
      # 設定されているメールアドレスに通知を送る
      (1..6).each do |i|
        email = notification_setting.send("email#{i}")
        NotificationMailer.comment_notification(email, comment).deliver_later if email.present?
      end
    end

end
  