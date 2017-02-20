## Page1

## Page2
* rails g controller posts index
* index.html.erbにhtmlべた書き
```erb
<div class="posts-index">
  <div class="posts-index-item">
    今日からProgateでRails勉強するよー！
  </div>
  <div class="posts-index-item">
    にんじゃわんこ可愛い。ひつじ仙人もイケメン。
  </div>
</div>
```

## Page3
* index.html.erbの中でそれぞれHashを定義
```erb
<% post1 = {content: '今日からProgateでRails勉強するよー！'} %>
<% post2 = {content: 'にんじゃわんこ可愛い。ひつじ仙人もイケメン。'} %>

<div class="posts-index">
  <div class="posts-index-item">
    <%= post1[:content] %>
  </div>
  <div class="posts-index-item">
    <%= post2[:content] %>
  </div>
</div>
```

## Page4
* index.html.erbでそれぞれのHashを配列にまとめる
* each文に書き換え
```erb
<%
  posts = [
    {content: '今日からProgateでRails勉強するよー！'},
    {content: 'にんじゃわんこ可愛い。ひつじ仙人もイケメン。'},
  ]
%>

<div class="posts-index">
  <% posts.each do |post| %>
    <div class="posts-index-item">
      <%= post[:content] %>
    </div>
  <% end %>
</div>
```

## Page5
* posts_controller.rb
```rb
def index
  @posts = [
    {content: '今日からProgateでRails勉強するよー！'},
    {content: 'にんじゃわんこ可愛い。ひつじ仙人もイケメン。'},
  ]
end
```
* index.html.erbの変数postを@postに変更

## Page6
* rails g migration create_posts content:text
* rails db:migrate

## Page7
* models/post.rbの作成
```rb
class Post < ApplicationRecord
end
```

## Page8
* rails console
```rb
1 + 2
```

## Page9
* rails console
```rb
post = Post.new(content: 'Hello world')
post.save
```

## Page10
* rails console
```rb
Post.all
post = Post.new(content: 'Learn to code, learn to be creative.')
post.save
Post.all
```

## Page11
* posts_controller.rb
```rb
@posts = Post.all
```

## Page12
* application.html.erbにヘッダー部分を追加
```erb
<header>
  <div class="header-logo">
    <a href="/"><img src="/images/wanko_icon.svg"></a>
  </div>
  <ul class="header-menus">
    <li><a href="/about">ABOUT</a></li>
  </ul>
</header>
```
* top.html.erbとabout.html.erbのヘッダー部分を削除

## Page13
* application.html.erbにlink_toを適用
* posts#indexへのリンクを追加
```erb
<ul class="header-menus">
  <li>
    <%= link_to 'ABOUT', '/about' %>
  </li>
  <li>
    <%= link_to '投稿一覧', '/posts/index' %>
  </li>
</ul>
```
