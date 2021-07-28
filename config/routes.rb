require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
  end
  root 'posts#index'

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[index new create show]
  # shallow: true
  # → comment_idを指定しないaction(index, new, create)はpost_idを指定し
  #   それ以外のactionではcomment_idのみを指定すれば良くなる
  # e.g.) shallow: false → post_comment  GET  /posts/:post_id/comments/:id(.:format)  comments#show
  #       shallow: true  → comment       GET  /comments/:id(.:format)                 comments#show
  resources :posts, shallow: true do
    collection do
      get :search
    end
    resources :comments
  end
  resources :likes, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :activities, only: [] do
    patch :read, on: :member
    get 'read', on: :member, to: 'activities#show'
  end

  namespace :mypage do
    resource :account, only: %i[edit update]
    resources :activities, only: %i[index]
  end
end
