class UserForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :user_id
  attr_accessor :name, :password, :password_confirmation, :email, :name_or_email

  def save
    user = User.new(name: name , password: password , password_confirmation: password_confirmation)
    user.user_detail = UserDetail.new(email: email)
    if user.save
      @user_id = user.id
      true
    else
      false
    end
  end

  def self.find_by(user_id)
    user = User.find_by(id: user_id)
    detail = user.user_detail
    @user_id = user.id
    UserForm.new(name: user.name , password: user.password , password_confirmation: user.password_confirmation , email: detail.email)
  end

  def self.find_by_user(keyword)
    user = User.new
    detail = UserDetail
    if keyword.match(UserDetail::VALID_EMAIL_REGEX)
      detail = UserDetail.find_by(email: keyword.downcase)
      detail.user
    else
      User.find_by(name: keyword)
    end
  end

end