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
      password: params[:password],
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

  def login_form
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.password == params[:password]
      session[:user_id] = @user.id
      flash[:notice] = 'ログインしました'
      redirect_to "/users/#{@user.id}"
    else
      @email = params[:email]
      @password = params[:password]
      @error_message = 'メールアドレスかパスワードに間違いがあります'
      render 'login_form'
    end
  end

  def logout
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to '/login'
  end
end
