class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  
  def new
    @user_form = UserForm.new
  end

  def create
    @user_form = UserForm.initialize_for_params(params: params_user_form)
    if @user_form.save
      redirect_to user_path(@user_form.user.id)
    else
      render :new
    end
  end

  def edit
    @user_form = UserForm.find_by(current_user.id)
  end

  def update
    @user_form = UserForm.find_by(params_user_form[:user][:id])
    if @user_form.update(params: params_user_form)
      redirect_to user_path(@user_form.user.id)
    else
      render :edit
    end
  end

  def show
    @user_form = UserForm.find_by(params[:id])
  end

  def params_user_form
    params.require(:user_form).permit!
  end
end
