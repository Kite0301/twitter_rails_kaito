# Instruction for lesson4
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
