# Instruction for lesson2
[Lesson4ストーリー](https://docs.google.com/document/d/1Jfm2_IGLO0TqHrL7QOVLEGU3sYyoPSLNLF_GKQkFvbU/edit)

## Page1
### 完成物の確認

## Page2
### rails consoleで更新と削除
* rails console
```rb
# 更新
post.content = 'Hello'
post.save
# 削除
post.destroy
```

## Page3
### 投稿編集ページの作成
* routes.rbを編集
```rb
get 'posts/:id/edit' => 'posts#edit'
```
* posts_controller.rbを編集
```rb
def edit
end
```
* edit.html.erbを作成
```erb
<div class="foods-new">
  <div class="form foods-form">
    <div class="form-header">編集する</div>
    <div class="form-body">
    </div>
  </div>
</div>
```
* show.html.erbを編集
```erb
<div class="post-menus">
  <%= link_to('編集', "/posts/#{@post.id}/edit") %>
</div>
```

## Page4
### 投稿フォームを作成しよう
* posts_controller.rbを編集
```rb
def edit
  @post = Post.find_by(id: params[:id])
end
```
* edit.html.erbを編集
```erb
<textarea><%= @post.content %></textarea>
<input type="submit" value="保存">
```

## Page5
### updateアクション
* routes.rbを編集
```rb
post 'posts/:id/update' => 'posts#update'
```
* posts_controller.rbを編集
```rb
def update
  redirect_to('/posts/index')
end
```
* edit.html.erbを編集
```erb
<%= form_tag "/posts/#{@post.id}/update" do %>
  <textarea><%= @post.content %></textarea>
  <input type="submit" value="保存">
<% end %>
```

## Page6
### 編集機能を実装しよう
* edit.html.erbを編集
```erb
<textarea name="content"><%= @post.content %></textarea>
```
* posts_controller.rbを編集
```rb
@post = Post.find_by(id: params[:id])
@post.content = params[:content]
@post.save
```

## Page7
### 削除機能の準備
* routes.rbを編集
```rb
post 'posts/:id/destroy' => 'posts#destroy'
```
* posts_controller.rbを編集
```rb
def destroy
end
```
* show.html.erbを編集
```erb
<%= link_to('削除', "/posts/#{@post.id}/destroy", method: :post) %>
```

## Page8
### 削除機能を実装しよう
* posts_controller.rbを編集
```rb
@post.find_by(id: params[:id])
@post.destroy
```

## Page9
### 空の投稿を防ごう
* models/post.rbの編集
```rb
validates :content, presence: true
```

## Page10
### 140字以内に制限しよう
* models/post.rbの編集
```rb
validates :content, presence: true, length: {maximum: 140}
```

## Page11
### バリデーションの結果で表示するページを変える(1)
* rails console
```rb
post = Post.new
post.save
# => false
post.content = 'Hello'
post.save
# => true
```

## Page12
### バリデーションの結果で表示するページを変える(2)
* posts_controller.rbを編集
```rb
def update
  # 中略
  if @post.save
    redirect_to('/posts/index')
  else
    redirect_to("/posts/#{post.id}/edit")
  end
end
```

## Page13
### フォームに初期値を入れよう
* posts_controller.rb
```rb
render 'edit'
```

## Page14
### エラーメッセージを表示しよう
* edit.html.erbを編集
```erb
<% @post.errors.full_messages.each do |message| %>
  <div class="form-error">
    <%= message %>
  </div>
<% end %>
```

## Page15
### サクセスメッセージを表示しよう
* posts_controller.rbを編集
```rb
flash[:notice] = '投稿を編集しました'
```
* layouts/application.html.erbを編集
```erb
<% if flash[:notice] %>
  <div class="flash">
    <%= flash[:notice] %>
  </div>
<% end %>
```

## Page16
### 新規作成・削除でもメッセージを出そう
* posts_controller.rbを編集
```rb
def create
  @post = Post.new(content: params[:content])
  if @post.save
    flash[:notice] = '投稿を作成しました'
    redirect_to('/posts/index')
  else
    render 'new'
  end
end

def destroy
  # 中略
  flash[:notice] = '投稿を削除しました'
end
```
* new.html.erbを編集
```erb
<div class="form-body">
  <% @post.errors.full_messages.each do |message| %>
    <div class="form-error">
      <%= message %>
    </div>
  <% end %>

  <%= form_tag '/posts/create' do %>
    <textarea name="content"><%= @post.content %></textarea>
    <input type="submit" value="投稿">
  <% end %>
</div>
```
