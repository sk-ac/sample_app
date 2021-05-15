class UsersController < ApplicationController
  # 下記のチェックは上から順番にチェックされる
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # ↓はログインした状態でしか呼び出せない関数なので、先に↑のbefore_actionが必要
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # GET /users/
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # GET /users/:id
  def show
    @user = User.find(params[:id])
    # debugger
  end
  
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # 編集画面を表示する
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # デフォルトで下記の処理へ遷移する
    # => app/views/users/edit.html.erb
  end

  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # @users.errors <= エラーデータが入っている
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
    # beforeアクション

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
      redirect_to(root_url) unless current_user?(@user)
    end
   
       # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
end
