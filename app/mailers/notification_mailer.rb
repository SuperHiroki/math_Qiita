# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
    def like_notification(email, likeable)
      @likeable = likeable
      mail(to: email, subject: '新しいいいねの通知')
    end
    
    def comment_notification(email, comment)
      @comment = comment
      mail(to: email, subject: '新しいコメントの通知')
    end
end
  