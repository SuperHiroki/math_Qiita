# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy
  has_one :notification, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  attribute :username, :string, default: 'NoName'
  attribute :icon_photo_name, :string, default: 'default.png'
  attribute :language, :string, default: 'Japanese'

  validates :username, format: { without: /\s/, message: "should not contain any spaces" }

  def generate_presigned_url(bucket_name, object_key, expires_in = 3600)
    s3_client = Aws::S3::Client.new
    signer = Aws::S3::Presigner.new(client: s3_client)

    # URLのプロトコルやドメインを取り除き、キーのみを抽出
    # 例: "https://bucket-name.s3.region.amazonaws.com/user-icon/AAA.png" から "user-icon/AAA.png" を抽出
    key = URI.parse(object_key).path.sub(/^\//, '')

    Rails.logger.debug "Generated key for S3 object: #{key}"
    
    signer.presigned_url(:get_object, bucket: bucket_name, key: key, expires_in: expires_in)
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[username]
  end
end
