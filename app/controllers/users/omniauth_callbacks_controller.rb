class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    auth = request.env["omniauth.auth"]
    Rails.logger.info "OmniAuth Info: #{auth.inspect}"

    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "LinkedIn") if is_navigational_format?
    else
      Rails.logger.error "User not persisted: #{@user.errors.full_messages.join(', ')}"
      session["devise.linkedin_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
