class RecipesController < ApplicationController

  wrap_parameters format: []
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_message

  before_action :authorize

  def index
    render json: Recipe.all, status: :created
  end

  def create
    recipe = @current_user.recipes.create!(recipe_params)
    render json: recipe, status: :created
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete, :user_id)
  end

  # Move the authorize to ApplicationController
  def authorize
    @current_user = User.find_by(id: session[:user_id])
    return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
  end

  def render_record_invalid_message(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end
