class SessionsController < ApplicationController
  def new
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.find_by_name_or_email(params[:session][:name_or_email])
    if @user_form.user && @user_form.user.authenticate(params[:session][:user][:password])
      session[:user_id] = @user_form.user.id
      redirect_to user_path(@user_form.user)
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'ログアウトしました'
    redirect_to new_session_path
  end
end
