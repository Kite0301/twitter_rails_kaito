# Instruction for lesson10
[Lesson10ストーリー](https://docs.google.com/document/d/11CfvQh7jQwYqIHWMe5Z2pwSy3Gh-uf5oqLTjOCwVubQ)

## Page1
### 完成物の確認
* お気に入り機能
* （お気に入りした投稿を一覧で表示）

## Page2
### いいね機能の仕組み
* likesテーブルの作成
  * `rails generate migration create_likes user_id:integer post_id:integer`
  * `rails db:migrate`

## Page3
### Likeモデルを作成しよう
* models/like.rbの作成
```rb
class Like < ApplicationRecord
  validates :user_id, {presence: true}
  validates :post_id, {presence: true}
end
```

## Page4
### likesテーブルのデータを作ってみよう
* rails console
```rb
like = Like.new(user_id: 1, post_id: 3)
like.save
```

## Page5
### いいねした投稿かどうかを表示しよう
* posts/show.html.erb
```erb
<% if @current_user && Like.find_by(user_id: @current_user.id, post_id: @post.id) %>
  いいね！済み
<% else %>
  いいね！していません
<% end %>
```

## Page6
### いいね！ボタンの準備
* likes_controller.rbの作成
```rb
class LikesController < ApplicationController
  before_action :authenticate_user, {only: [:create]}

  def create
  end
end
```
* routes.rb
```rb
post "likes/:post_id/create" => "likes#create"
```

## Page7
### いいね！ボタンを作ろう
* posts/show.html.erb
  * else文中
```erb
<%= link_to('いいね！', "/likes/#{@post.id}/create", {method: 'post'}) %>
```
* likes_controller.rb
```rb
def create
  @like = Like.new(user_id: @current_user.id, post_id: params[:post_id])
  @like.save
  redirect_to "/posts/#{params[:post_id]}"
end
```

## Page8
### いいね！取り消しボタンを作ろう
* routes.rb
```rb
post "likes/:post_id/destroy" => "likes#destroy"
```

* likes_controller.rb
```rb
def destroy
  @like = Like.find_by(user_id: @current_user.id, post_id: params[:post_id])
  @like.destroy
  redirect_to "/posts/#{params[:post_id]}"
end
```

* posts/show.html.erb
```erb
<%= link_to('いいね！済み', "/likes/#{@post.id}/destroy", {method: 'post'}) %>
```

## Page9
### いいねの数を取得しよう
* rails console
```rb
Like.all.count
Like.where(post_id: 1).count
```

## Page10
### いいねの数を表示しよう
* posts_controller.rb
  * showアクション内
```rb
@likes_count = Like.where(post_id: @post.id).count
```

* posts/show.html.erb
```erb
<%= @likes_count %>
```

## Page11
### いいねボタンをアイコンにしよう
* application.htm.erb
```erb
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
```

* posts/show.html.erb
```erb
<% if @current_user && Like.find_by(user_id: @current_user.id, post_id: @post.id) %>
  <%= link_to("/likes/#{@post.id}/destroy", {method: "post"}) do %>
    <span class="fa fa-heart like-btn-unlike">
      <%= @likes_count %>
    </span>
  <% end %>
<% else %>
  <%= link_to("/likes/#{@post.id}/create", {method: "post"}) do %>
    <span class="fa fa-heart like-btn">
      <%= @likes_count %>
    </span>
  <% end %>
<% end %>
```

## Page12
### いいねした投稿の一覧を表示しよう（1）
* routes.rb
```rb
get "users/:id/likes" => "users#likes"
```

* users_controller.rb
```rb
def likes
end
```

* users/like.html.erbを作成

* users/show.html.erbにリンク作成
```erb
<ul class="user-tabs">
  <li class="active"><%= link_to("投稿", "/users/#{@user.id}") %></li>
  <li><%= link_to("いいね!", "/users/#{@user.id}/likes") %></li>
</ul>
```

## Page13
### いいねした投稿の一覧を表示しよう（2）
* users_controller.rb
```rb
def likes
  @user = User.find_by(id: params[:id])
  @likes = Like.where(user_id: @user.id)
end
```
* users/like.html.erb
```erb
<div class="main user-show">
  <div class="container">
    <div class="user">
      <img src="<%= @user.image %>">
      <h2><%= @user.name %></h2>
      <p><%= @user.email %></p>
      <% if @user.id == @current_user.id %>
        <a href="/users/<%= @current_user.id %>/edit">プロフィールの編集 </a>
      <% end %>
    </div>

    <ul class="user-tabs">
      <li><%= link_to("投稿", "/users/#{@user.id}") %></li>
      <li class="active"><%= link_to("いいね!", "/users/#{@user.id}/likes") %></li>
    </ul>

    <% @likes.each do |like| %>
      <% post = Post.find_by(id: like.post_id) %>
      <% post_user = User.find_by(id: post.user_id) %>
      <div class="posts-index-item">
        <div class="post-left"><img src="<%= post_user.image %>"></div>
        <div class="post-right">
          <div class="post-user-name">
            <%= link_to(post_user.name, "/users/#{post_user.id}") %>
          </div>
          <%= link_to(post.content, "/posts/#{post.id}") %>
        </div>
      </div>
    <% end %>
  </div>
</div>
```
