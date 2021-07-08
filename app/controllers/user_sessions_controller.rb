class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password])

    if @user
      # redirect_back_or_to: 保存されたURLがある場合にそのURLに、ない場合は指定されたURLにリダイレクトする
      # e.g.) 「User#editページに遷移 => 認証が必要 => ログインページに飛ぶ」の挙動の際にUser#editページが保存され
      #        ログイン成功後にUser#editにリダイレクトされる
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました'
  end
end