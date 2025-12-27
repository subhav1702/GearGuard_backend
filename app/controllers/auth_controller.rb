class AuthController < ApplicationController
  skip_before_action :authorize_request, only: %i[signup login forgot_password reset_password]

  # POST /signup
  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        message: "Account created successfully",
        token: token,
        user: user.slice(:id, :name, :email, :role)
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        message: "Login successful",
        token: token,
        user: user.slice(:id, :name, :email, :role)
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def forgot_password
    user = User.find_by(email: params[:email])
  
    return render json: { message: "If that account exists, a reset link has been sent" },
                  status: :ok unless user
  
    token = user.generate_reset_password_token!
  
    # For now return token in response (replace w/ email later)
    render json: {
      message: "Password reset token generated",
      reset_token: token,
      expires_in: "30 minutes"
    }
  end

  def reset_password
    user = User.find_by(email: params[:email])
  
    return render json: { error: "Invalid account" },
                  status: :not_found unless user
  
    unless params[:token].present? && params[:password].present?
      return render json: { error: "Token and password are required" },
                    status: :unprocessable_entity
    end
  
    unless user.reset_token_valid?(params[:token])
      return render json: { error: "Invalid or expired reset token" },
                    status: :unauthorized
    end
  
    if user.update(password: params[:password])
      user.clear_reset_password_token!
  
      render json: {
        message: "Password reset successful",
        token: JsonWebToken.encode(user_id: user.id)
      }, status: :ok
    else
      render json: { errors: user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # GET /me
  def me
    render json: current_user.slice(:id, :name, :email, :role)
  end

  private

  def user_params
    params.permit(:name, :email, :password, :role)
  end
end
