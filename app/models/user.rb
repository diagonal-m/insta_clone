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
end
