# Instruction for lesson5
[旧Lesson4ストーリー](https://docs.google.com/document/d/1Jfm2_IGLO0TqHrL7QOVLEGU3sYyoPSLNLF_GKQkFvbU/edit)

## Page1
### 完成物の確認

## Page2
### 空の投稿を防ごう
* models/post.rbの編集
```rb
validates :content, presence: true
```

## Page3
### 140字以内に制限しよう
* models/post.rbの編集
```rb
validates :content, presence: true, length: {maximum: 140}
```

## Page4
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

## Page5
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

## Page6
### フォームに初期値を入れよう
* posts_controller.rb
```rb
render 'edit'
```

## Page7
### エラーメッセージを表示しよう
* edit.html.erbを編集
```erb
<% @post.errors.full_messages.each do |message| %>
  <div class="form-error">
    <%= message %>
  </div>
<% end %>
```

## Page8
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

## Page9
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
