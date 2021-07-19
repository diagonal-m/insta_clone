# == Schema Information
#
# Table name: users
#
#  id               :bigint           not null, primary key
#  avatar           :string(255)
#  crypted_password :string(255)
#  email            :string(255)      not null
#  salt             :string(255)
#  username         :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  authenticates_with_sorcery!  # Userモデルで必要なクラスメソッドとインスタンスメソッドが得られる

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true
  # バリデーションの実行直前に呼び出されるメソッド名をシンボルで:ifや:unlessオプションに指定できる。
  # new_record?メソッド: インスタンスが新規に作成されるものかどうかを判定
  # if: -> { new_record? || changes[:crypted_password] }
  # → ユーザーがパスワード以外のプロフィール項目を更新したい場合に、パスワードの入力を省略できるようになる。
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  has_many :active_relationships, class_name:  'Relationship',
            foreign_key: 'follower_id',
            dependent:   :destroy
  has_many :passive_relationships, class_name:  'Relationship',
            foreign_key: 'followed_id',
            dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  scope :recent, ->(count) { order(created_at: :desc).limit(count) }

  def own?(object)
    id == object.user_id
  end

  def like(post)
    like_posts << post
  end

  def unlike(post)
    like_posts.destroy(post)
  end

  def like?(post)
    like_posts.include?(post)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.destroy(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Post.where(user_id: following_ids << id)
  end
end
