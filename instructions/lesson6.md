# Instruction for lesson6
[Lesson5ストーリー（鈴木介翔）](https://docs.google.com/document/d/1EvkLwPY3J4F8T78i8h14DdBePYw_XPSsI2kfQ07I-Aw/edit)

## Page1
### 完成物の確認

## Page2
### Userモデルを作ろう
* rails g migration User name:string email:string
* rails db:migrate
* models/user.rbの作成
```rb
class User < ApplicationRecord
end
```

## Page3
### Userモデルのバリデーション
* models/user.rbを編集
```rb
validates :name, presence: true
validates :email, presence: true, uniqueness: true
```

## Page4
### UsersControllerを作ろう
* rails g controller users show
* users_controller.rbを編集
```rb
def show
  @user = User.find_by(id: params[:id])
end
```
* users/show.html.erbを編集
```erb
<div class="user-show">
  <div class="user">
    <h2>ユーザー名</h2>
    <p><%= @user.name %></p>
    <h2>メールアドレス</h2>
    <p><%= @user.email %></p>
  </div>
</div>
```

## Page5
### ユーザー登録フォームの準備
* newアクションの作成
  * routes.rb
```rb
get '/signup' => 'users#new'
```
  * users_controller.rb
```rb
def new
  @user = User.new
end
```
  * new.html.erb
```erb
<div class="users-new">
  <div class="form users-form">
    <div class="form-header">新規ユーザー登録</div>
    <div class="form-body">
    </div>
  </div>
</div>
```
* リンク追加
  * home/top.html.erb
```erb
<%= link_to('ユーザー登録', '/signup') %>
```

## Page6
### ユーザー登録フォームを作ろう
* new.html.erbを編集
```erb
<h2>ユーザー名</h2>
<input value="<%= @user.name %>">
<h2>メールアドレス</h2>
<input value="<%= @user.email %>">
```

## Page7
### createアクションの作成
* createアクションの作成
  * routes.rb
```rb
post 'users/create' => 'users#create'
```
  * users_controller.rb
```rb
def create
  redirect_to('/posts/index')
end
```
* new.html.erbを編集
```erb
<%= form_tag '/users/create' do %>
<!-- 中略 -->
<% end %>
```

## Page8
### createアクションの実装
* new.html.erbを編集
  * name属性の追加
```erb
<h2>ユーザー名</h2>
<input name="name" value="<%= @user.name %>">
<h2>メールアドレス</h2>
<input name="email" value="<%= @user.email %>">
```
* users_controller.rbを編集
```rb
@user = User.new(name: params[:name], email: params[:email])
if @user.save
  redirect_to('/posts/index')
else
  render 'new'
end
```

## Page9
### メッセージを表示しよう
* エラーメッセージ
  * new.html.erb
```erb
<% @user.errors.full_messages.each do |message| %>
  <div class="form-error">
    <%= message %>
  </div>
<% end %>
```
* サクセスメッセージ
  * createアクション
```rb
flash[:notice] = 'ユーザー登録が完了しました'
```

## Page10
### ユーザー編集ページの作成
* editアクションの作成
  * routes.rb
```rb
get 'users/:id/edit' => 'users#edit'
```
  * users_controller.rb
```rb
def edit
  @user = User.find_by(id: params[:id])
end
```
  * edit.html.erb
```erb
<div class="users-edit">
  <div class="form users-form">
    <div class="form-header">アカウント編集</div>
    <div class="form-body">
      <h2>名前</h2>
      <input value="<%= @user.name %>">
      <h2>メールアドレス</h2>
      <input value="<%= @user.email %>">
      <input type="submit" value="保存">
    </div>
  </div>
</div>
```
* リンクの作成
  * show.html.erb
```erb
<%= link_to('プロフィールの編集', "/users/#{@user.id}/edit") %>
```

## Page11
### updateアクション
* routes.rb
```rb
post 'users/:id/update' => 'users#update'
```
* users_controller.rb
```rb
def update
  @user = User.find_by(id: params[:id])
  @user.name = params[:name]
  @user.email = params[:email]
  if @user.save
    flash[:notice] = 'アカウント情報を編集しました'
    redirect_to "/users/#{@user.id}"
  else
    render 'edit'
  end
end
```
* edit.html.erb
```erb
<div class="form-body">
  <% @user.errors.full_messages.each do |message| %>
    <div class="form-error">
      <%= message %>
    </div>
  <% end %>

  <%= form_tag("/users/#{@user.id}/update") do %>
    <h2>名前</h2>
    <input name="name" value="<%= @user.name %>">
    <h2>メールアドレス</h2>
    <input name="email" value="<%= @user.email %>">
    <input type="submit" value="保存">
  <% end %>
</div>
```

## Page12
### ユーザー画像を用意しよう
* imageカラム追加
  * rails g migration add_image_to_users image:string
  * rails db:migrate

## Page13
### 初期画像を設定しよう
* users_controller.rbを編集
  * createアクション
```rb
@user = User.new(
  name: params[:name],
  email: params[:email],
  image: '/images/default_user.jpg',
)
```

## Page14
### 画像編集ボタンを用意しよう
* users/edit.html.erbを編集
```erb
<h2>画像</h2>
<input name="image" type="file">
```

## Page15
### ファイルへの書き込み
* rails console
```rb
File.write('public/sample.txt', 'hoge')
```

## Page16
### 画像を保存しよう
* users_controller.rbを編集
  * updateアクション
```rb
file = params[:image]
if file
  @user.image = "/user_images/#{@user.id}.png"
  File.binwrite("public#{@user.image}", file.read)
end
```
* edit.html.erb
  * `multipart: true`を追加
```erb
<%= form_tag "/users/#{@user.id}/update", multipart: true do %>
```

## Page17
### 画像を表示しよう
* show.html.erbを編集
```erb
<img src="<%= @user.image %>">
```
