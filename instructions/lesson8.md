# Instruction for lesson8
[Lesson8ストーリー](https://docs.google.com/document/d/1iwfAy7BRdnGpTq2u76ZepGeUoRNwRU7zueYeksiz-dw)

## Page1
### 完成物の確認
* ユーザー登録
* ログイン
* ログアウト

## Page2
### passwordカラムを追加しよう
* rails g migration add_password_to_users password:string
* rails db:migrate
* DBプレビューで確認
* バリデーションの追加
  * models/user.rb
```rb
validates :password, presence: true
```

## Page3
### 新規登録フォームにpasswordを追加しよう
* new.html.erb
```erb
<h2>パスワード</h2>
<input type="password" name="password" value="<%= @user.password %>">
```

## Page4
### ログインフォームを作ろう
* login_formアクションの追加
  * routes.rb
```rb
get '/login' => 'users#login_form'
```
  * users_controller.rb
```rb
def login_form
end
```
  * login_form.html.erb
```erb
<div class="users-new">
  <div class="form users-form">
    <div class="form-header">ログイン</div>
    <div class="form-body">

      <%= form_tag '/login' do %>
        <h2>メールアドレス</h2>
        <input name="email">
        <h2>パスワード</h2>
        <input type="password" name="password">
        <input type="submit" value="ログイン">
      <% end %>
    </div>
  </div>
</div>
```

## Page5
### ログイン機能を作ろう
* loginアクションの作成
  * routes.rb
```rb
post '/login' => 'users#login'
```
  * users_controller.rb
```rb
def login
  @user = User.find_by(email: params[:email])
  if @user && @user.password == params[:password]
    flash[:notice] = 'ログインしました'
    redirect_to "/users/#{@user.id}"
  else
    @email = params[:email]
    @password = params[:password]
    @error_message = 'メールアドレスかパスワードに間違いがあります'
    render 'login_form'
  end
```
* エラーメッセージ・初期値の表示
  * login_form.html.erb
```erb
<% if @error_message %>
  <div class="form-error">
    <%= @error_message %>
  </div>
<% end %>

<!-- 中略 -->

<input name="email" value="<%= @email %>">
<input type="password" name="password" value="<%= @password %>">
```

## Page6
### ログイン状態を維持しよう（セッション）
* セッションの追加
  * users_controller.rb
```rb
session[:user_id] = @user.id
```

## Page7
### ログインユーザーの情報を表示しよう
* 変数`@current_user`を使用する
  * posts_controller.rb
```rb
def index
  @current_user = User.find_by(id: session[:user_id])
end
```
  * layouts/application.html.erb
```erb
<li><a href="/users/<%= @current_user.id %>"><%= @current_user.name %></a></li>
```

## Page8
### 全アクションで@current_userを定義しよう
* application_controller.rb
```rb
before_action :set_current_user

# 中略

def set_current_user
  @current_user = User.find_by(id: session[:user_id])
end
```

## Page9
### ログアウト機能を作ろう
* logoutアクションの作成
  * routes.rb
```rb
post '/logout' => 'users#logout'
```
  * users_controller.rb
```rb
def logout
  session.delete(:user_id)
  flash[:notice] = 'ログアウトしました'
  redirect_to '/login'
end
```
* ログアウト用のリンク追加
  * layouts/application.html.erb
```erb
<li>
  <%= link_to('ログアウト', '/logout', method: :post) %>
</li>
```

## Page10
### ログイン前後でヘッダーを変えよう
* layouts/application.html.erb
```erb
<% if @current_user %>
  <li><a href="/users/<%= @current_user.id %>"><%= @current_user.name %></a></li>
  <li><a href="/posts/index">投稿一覧</a></li>
  <li><a href="/posts/new"><span class="fa fa-edit"></span>新規投稿</a></li>
  <li>
    <%= link_to('ログアウト', '/logout', method: :post) %>
  </li>
<% else %>
  <li><a href="/about">ABOUT</a></li>
<% end %>
```

## Page11
### ログインしているかチェックしよう
* posts_controller.rb
```rb
def edit
  if !@current_user
    flash[:notice] = 'ログインが必要です'
    redirect_to '/login'
  end
  @post = Post.find_by(id: params[:id])
end
```

## Page12
### ログインチェックをbefore_action化しよう
* application_controller.rb
```rb
def authenticate_user
  if !@current_user
    flash[:notice] = 'ログインが必要です'
    redirect_to '/login'
  end
end
```
* posts_controller.rb
```rb
before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy]
```
* users_controller.rb
```rb
before_action :authenticate_user, only: [:edit, :update]
```
## Page13
### ユーザー情報の編集を制限しよう
* users_controller.rb
```rb
class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  # 中略

  private

  def ensure_correct_user
    if @current_user.id != params[:id].to_i
      flash[:notice] = '権限がありません'
      redirect_to '/posts/index'
    end
  end
end
```

## Page14
### トップページはログイン前のユーザーしか見れないようにしよう
* application_controller.rb
```rb
def forbid_login_user
  if @current_user
    redirect_to '/posts/index'
  end
end
```
* home_controller.rb
```rb
before_action :forbid_login_user, only: [:top]
```
* users_controller.rb
```rb
before_action :forbid_login_user, only: [:new, :create, :login_form, :login]
```

## Page15
### 新規ユーザー作成後に、そのままログイン状態になるようにしよう
* users_controller.rb
  * createアクションを編集
```rb
session[:user_id] = @user.id
```
