class UsersController < ApplicationController
  def new
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.new(params_user_form)
    if @user_form.save
      redirect_to user_path(@user_form.user_id)
    else
      render :new
    end
  end

  def show
    @user_form = UserForm.find_by(params[:id])
  end

  def params_user_form
    params.require(:user_form).permit(:name, :password, :password_confirmation, :email)
  end
end
