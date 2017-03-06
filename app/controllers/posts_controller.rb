class PostsController < ApplicationController
  before_action :authenticate_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = User.find_by(id: @post.user_id)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id,
    )
    if @post.save
      flash[:notice] = '投稿を作成しました'
      redirect_to('/posts/index')
    else
      render 'new'
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = '投稿を編集しました'
      redirect_to('/posts/index')
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = '投稿を削除しました'
    redirect_to('/posts/index')
  end

  private

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @current_user.id != @post.user_id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end
end
