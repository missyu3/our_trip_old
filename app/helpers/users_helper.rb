module UsersHelper
  def choose_method_new_or_edit
    if action_name == 'new'
      :post
    elsif action_name == 'edit'
      :patch
    end
  end
end
