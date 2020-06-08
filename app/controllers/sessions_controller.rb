class SessionsController < ApplicationController
  def new
    @user_form = UserForm.new
  end

  def create
    user = UserForm.find_by_user(params[:session][:name_or_email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      @user_form = UserForm.new
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end
end
