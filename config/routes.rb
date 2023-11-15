Rails.application.routes.draw do
  #ホーム画面
  root 'home#index' 

  #ログイン管理
  devise_for :users # /users/sign_in, /users/sign_out, /users/sign_up

  #Posts関連
  resources :posts, except: [:show, :edit, :update, :destroy]
  get '/:username/items/:link', to: 'posts#show'
  get '/:username/items/:link/edit', to: 'posts#edit'
  patch '/:username/items/:link', to: 'posts#update'
  delete '/:username/items/:link', to: 'posts#destroy'
  get 'articles', to: 'posts#articles'
  get 'questions', to: 'posts#questions'
  get 'drafts', to: 'posts#drafts'

  #コメントといいね
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
  end

  resources :comments do
    resources :likes, only: [:create, :destroy]
  end

  #設定
  get 'settings/account', to: 'settings#account'
  patch 'settings/account', to: 'settings#update_account', as: 'update_account_settings'

  get 'settings/profile', to: 'settings#profile'
  patch 'settings/profile', to: 'settings#update_profile', as: 'update_profile_settings'

  get 'settings/notification', to: 'settings#notification'
  patch 'settings/notification', to: 'settings#update_notification', as: 'update_notification_settings'

  #mypage
  get '/:username/mypage/profile', to: 'mypage#profile'

  get '/:username/mypage/articles', to: 'mypage#articles'
  get '/:username/mypage/comments', to: 'mypage#comments'

  get '/:username/mypage/questions', to: 'mypage#questions'
  get '/:username/mypage/answers', to: 'mypage#answers'

  get '/:username/mypage/likes/articles', to: 'mypage#likes_articles'
  get '/:username/mypage/likes/comments', to: 'mypage#likes_comments'
  get '/:username/mypage/likes/questions', to: 'mypage#likes_questions'
  get '/:username/mypage/likes/answers', to: 'mypage#likes_answers'

  #いいねのカウント
  get '/likes/count', to: 'likes#count'

  #テスト
  get "hello", to: "hello#index"

end

