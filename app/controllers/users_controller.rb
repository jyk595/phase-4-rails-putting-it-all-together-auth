class UsersController < ApplicationController
  wrap_parameters format: []

  def create
    user = User.create(user_params)
    
    if user.valid?
      render json: user, status: :created
      session[:user_id] = user.id
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    user = User.find_by!(id: session[:user_id])
    render json: user, status: :created
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end

end
