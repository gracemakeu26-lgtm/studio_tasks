module UsersHelper
  def role_label(user)
    { "manager" => "Gérante", "esthetician" => "Esthéticienne","receptionist" => "Réceptionniste" }.fetch(user.role, user.role)
  end
end

