class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split.last if header

    decoded = JsonWebToken.decode(token)

    return render json: { error: "Invalid or expired token" }, status: :unauthorized unless decoded

    @current_user = User.find_by(id: decoded[:user_id])

    return render json: { error: "User not found" }, status: :unauthorized unless @current_user
  end
end
