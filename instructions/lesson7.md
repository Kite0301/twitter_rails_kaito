# Instruction for lesson7
[旧Lesson5ストーリー（鈴木介翔）](https://docs.google.com/document/d/1EvkLwPY3J4F8T78i8h14DdBePYw_XPSsI2kfQ07I-Aw/edit)

## Page1
### 完成物の確認

## Page2
### ユーザー画像を用意しよう
* imageカラム追加
  * rails g migration add_image_to_users image:string
  * rails db:migrate

## Page3
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

## Page4
### 画像編集ボタンを用意しよう
* users/edit.html.erbを編集
```erb
<h2>画像</h2>
<input name="image" type="file">
```

## Page5
### ファイルへの書き込み
* rails console
```rb
File.write('public/sample.txt', 'hoge')
```

## Page6
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

## Page7
### 画像を表示しよう
* show.html.erbを編集
```erb
<img src="<%= @user.image %>">
```
