# Instruction for lesson9
[Lesson9ストーリー](https://docs.google.com/document/d/1xV4Jin3WO2kCnXwsRtBYXGU769hAzlN88WwKzSVDDN0)

## Page1
### 完成物の確認
* 投稿一覧
* 投稿詳細
* ユーザー詳細

## Page2
### ユーザーと投稿を紐付けよう
* rails g migration add_user_id_to_posts user_id:integer
* rails db:migrate
* DBプレビューで確認
* バリデーションの追加
  * models/posts.rb
```rb
validates :user_id, presence: true
```

## Page3
### 新規投稿をログインユーザーに紐付けよう
* users_controller.rb
  * createアクション
```rb
@post = Post.new(
  content: params[:content],
  user_id: @current_user.id,
)
```

## Page4
### 投稿にユーザー名を表示しよう
* posts_controller.rb
  * showアクション
```rb
@user = User.find_by(id: @post.user_id)
```
* posts/show.html.erb
```erb
<div class="post-user-name">
  <img src="<%= @user.image %>">
  <%= link_to(@user.name, "/users/#{@user.id}") %>
</div>
```

## Page5
### 投稿一覧にもユーザー名を表示しよう
* posts/index.html.erb
```erb
<% @posts.each do |post| %>
  <% user = User.find_by(id: post.user_id) %>
  <div class="posts-index-item">
    <div class="post-left">
      <img src="<%= user.image %>">
    </div>
    <div class="post-right">
      <div class="post-user-name">
        <%= link_to(user.name, "/users/#{user.id}") %>
      </div>
      <%= link_to(post.content, "/posts/#{post.id}") %>
    </div>
  </div>
<% end %>
```

## Page6
### ユーザー詳細に投稿を表示しよう（準備）
* rails console
```rb
posts = Post.where(user_id: 1)
posts[0].content
```
## Page7
### ユーザー詳細に投稿を表示しよう
* users_controller.rb
  * showアクション
```rb
@posts = Post.where(user_id: @user.id)
```
* users/show.html.erb
```erb
<% @posts.each do |post| %>
  <div class="posts-index-item">
    <div class="post-left"><img src="<%= @user.image %>"></div>
    <div class="post-right">
      <div class="post-user-name">
        <%= link_to(@user.name, "/users/#{@user.id}") %>
      </div>
      <%= link_to(post.content, "/posts/#{post.id}") %>
    </div>
  </div>
<% end %>
```

## Page8
### 投稿者だけが編集できるようにしよう（ビュー）
* posts/show.html.erb
```erb
<div class="post-menus">
  <% if @user.id == @current_user.id %>
    <%= link_to("編集", "/posts/#{@post.id}/edit") %>
    <%= form_tag("/posts/#{@post.id}/destroy") do %>
      <input type="submit" value="削除">
    <% end %>
  <% end %>
</div>
```

## Page9
### 投稿者だけが編集できるようにしよう（アクション）
* posts_controller.rb
```rb
before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

# 中略

private

def ensure_correct_user
  @post = Post.find_by(id: params[:id])
  if @current_user.id != @post.user_id
    flash[:notice] = "権限がありません"
    redirect_to("/posts/index")
  end
end
```
