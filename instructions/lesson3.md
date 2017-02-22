# Instruction for lesson3
[Lesson3ストーリー](https://docs.google.com/document/d/1pS9ZSj6JG1DOmmujLjXUBHFd5RNzDK_5JuwdGvJ2h1k/edit)

## Page1
### 完成物の確認

## Page2
### 自動生成されるカラム
* rails consoleで確認
  * id
  * created_at

## Page3
### 投稿詳細ページのルーティング
* routes.rbを編集
```rb
get '/posts/:id' => 'posts#show'
```

* posts_controller.rbを編集
```rb
def show
end
```

* posts/show.html.erbの作成
```erb
<div class="posts-show">
  <div class="posts-show-item">
    <p>こんにちは<p>
    <div class="post-time">2017/02/21 12:28</div>
  </div>
</div>
```

## Page4
### paramsでidを取得
* posts_controller.rbを編集
```rb
def show
  @id = params[:id]
end
```

* posts/show.html.erbの作成
```erb
<div class="posts-show-item">
  <p>
    <%= @id %>
  <p>
  <div class="post-time">2017/02/21 12:28</div>
</div>
```

## Page5
### find_by
* rails console
```rb
post = Post.find_by(id: 1)
post.content
```

## Page6
### 詳細画面に投稿を表示しよう
* posts_controller.rbを編集
```rb
def show
  @post = Post.find_by(id: params[:id])
end
```
* show.html.erbを編集
```erb
<div class="posts-show-item">
  <p>
    <%= @post.content %>
  <p>
  <div class="post-time"><%= @post.created_at %></div>
</div>
```

## Page7
### 詳細画面へのリンクを作成しよう
* index.html.erbを編集
```erb
<%= link_to(post.content, "/post/#{post.id}") %>
```

## Page8
### 新規投稿機能の準備
* routes.rbを編集
```rb
get 'posts/new' => 'posts#new'
```
* posts_controller.rbを編集
```rb
def new
end
```
* new.html.erbを作成
```erb
<div class="foods-new">
  <div class="form foods-form">
    <div class="form-header">投稿する</div>
    <div class="form-body">
    </div>
  </div>
</div>
```
* application.html.erbを編集
```erb
<li>
  <%= link_to '新規投稿', '/posts/new' %>
</li>
```

## Page9
### フォームの見た目を作成しよう
* new.html.erbを編集
```erb
<textarea></textarea>
<input type="submit" value="投稿">
```

## Page10
### 投稿先のアクションを用意しよう
* routes.rbを編集
```rb
post 'posts/create' => 'posts#create'
```
* posts_controller.rbを編集
```rb
def create
  redirect_to '/posts/index'
end
```

## Page11
### フォームの送信先を指定しよう
* new.html.erbを編集
```erb
<%= form_tag '/posts/create' do %>
  <textarea></textarea>
  <input type="submit" value="投稿">
<% end %>
```

## Page12
### 投稿内容を保存しよう
* new.html.erbの編集
```erb
<textarea name="content"></textarea>
```

* posts_controller.rbの編集
```rb
post = Post.new(content: params[:content])
post.save
```
