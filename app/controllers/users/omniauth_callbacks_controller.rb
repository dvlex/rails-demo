class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def linkedin
    auth = request.env["omniauth.auth"]
    Rails.logger.info "OmniAuth Info: #{OmniauthLogBlueprint.render(auth)}"

    @user = User.from_omniauth(auth)

    if @user.persisted?
      # Check if the request comes from the React App
      # OmniAuth stores the params from the request phase in request.env['omniauth.params']
      origin = request.env["omniauth.params"]&.fetch("origin", nil)

      if origin == "react"
        # Generate JWT token for React App
        token, _payload = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil)

        # Redirect to React frontend with the token
        frontend_url = "http://localhost:5173/auth/callback"
        redirect_to "#{frontend_url}?token=#{token}", allow_other_host: true
        return
      end

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
