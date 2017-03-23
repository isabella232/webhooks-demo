class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :address_line1, :address_line2, :address_city, :address_state,
                                 :address_zip, :address_country, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :address_line1, :address_line2, :address_city, :address_state,
                                 :address_zip, :address_country, :email, :password, :password_confirmation, :current_password)
  end
end
