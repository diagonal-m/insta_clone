# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  belongs_to :user
  # mount_uploader: carrierwave用に作ったカラム名, carrierwaveの設定ファイルのクラス名
  # → モデルに紐づけることができる
  mount_uploaders :images, PostImageUploader
  # JSON にシリアライズして１カラムに保存
  serialize :images, JSON

  validates :images, presence: true
  validates :body, presence: true, length: { maximum: 1000 }

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  has_many :like_users, through: :likes, source: :user
  has_one :activity, as: :subject, dependent: :destroy

  scope :body_contain, ->(word) { where('posts.body LIKE ?', "%#{word}%") }
  scope :comment_body_contain, ->(word) { joins(:comments).where('comments.body LIKE ?', "%#{word}%") }
  scope :username_contain, ->(word) { joins(:user).where('username LIKE ?', "%#{word}%") }
end
