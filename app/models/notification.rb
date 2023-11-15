# app/models/notification.rb
class Notification < ApplicationRecord
    belongs_to :user
  
    # URI::MailTo::EMAIL_REGEXP を使用して標準のメールフォーマットをバリデート
    validates :email1, :email2, :email3, :email4, :email5, :email6,
              allow_blank: true,
              format: { with: URI::MailTo::EMAIL_REGEXP }
  end
  