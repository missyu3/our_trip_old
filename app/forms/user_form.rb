class UserForm
  include ActiveModel::Model
  

  attr_accessor  :user ,:user_detail ,:name_or_email, :errors

  def self.initialize_for_params(params: {})
    user_form = release_params(params: params)
    user = user_form.user
    user_detail = user_form.user_detail
    return UserForm.new(user: user,user_detail: user_detail) 
  end

  def save
    @errors = []
    @user.user_detail = @user_detail if @user_detail.present?
    return true if @user.save
    @errors << @user.errors.full_messages
    @errors.flatten!
    false
  end

  def update(params: {})
    @errors = []
    user_form = UserForm.find_by(@user.id)
    ActiveRecord::Base.transaction(joinable: false, requires_new: true) do
      
      unless user_form.user.update(params[:user])
        @errors << user_form.user.errors.full_messages
        raise ActiveRecord::Rollback 
      end
      if params[:user_detail].present? && !(user_form.user_detail.update(params[:user_detail]))
        @errors << user_form.user_detail.errors.full_messages
        raise ActiveRecord::Rollback
      end
    end
    unless @errors.present? 
      @user = user
      @user_detail = user.user_detail
      true
    else
      @errors.flatten!
      false
    end
  end

  def gest_user?
    #user_detailに情報がない場合はGestUserと判断する。
    @user.user_detail.blank?
  end

  def self.find_by(user_id)
    user = User.find_by(id: user_id)
    detail = user.user_detail 
    return UserForm.new(user: user,user_detail: detail)
  end

  def self.find_by_name_or_email(name_or_email)
    if name_or_email.match(UserDetail::VALID_EMAIL_REGEX)
      detail = UserDetail.find_by(email: name_or_email.downcase)
      user = detail.user if user.present?
    else
      user = User.find_by(name: name_or_email)
      detail = user.user_detail if user.present?
    end
    UserForm.new(user: user , user_detail: detail, name_or_email: name_or_email)
  end

  private

  def self.release_params(params: {})
    user = User.new(params[:user])
    user_detail = UserDetail.new(params[:user_detail]) if params[:user_detail].present?
    UserForm.new(user: user , user_detail: user_detail)
  end

end