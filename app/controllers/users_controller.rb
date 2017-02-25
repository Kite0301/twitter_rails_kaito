class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image: '/images/default_user.jpg',
    )

    if @user.save
      flash[:notice] = 'ユーザー登録が完了しました'
      redirect_to('/posts/index')
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    file = params[:image]
    if file
      @user.image = "/user_images/#{@user.id}.png"
      File.binwrite("public#{@user.image}", file.read)
    end
    if @user.save
      flash[:notice] = 'アカウント情報を編集しました'
      redirect_to "/users/#{@user.id}"
    else
      render 'edit'
    end
  end
end
