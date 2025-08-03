class ShelvesController < ApplicationController
  before_action :get_profile
  def index
    if @profile
      render json: ShelfSerializer.new(@profile.shelves).serializable_hash
    else
      render json: { message: "Profile not found" }, status: :not_found
    end
  end

  def show
    if @profile
      shelf = @profile.shelves.find_by(id: params[:id])

      if shelf
        render json: ShelfSerializer.new(shelf, include: [:shelf_books, :owned_books]).serializable_hash
      else
        render json: { message: "Shelf not found" }, status: :not_found
      end

    else
      render json: { message: "Profile not found" }, status: :not_found
    end
  end

  def create
    if @profile
      shelf = @profile.shelves.new(shelf_params)
      if shelf.save
        render json: ShelfSerializer.new(shelf).serializable_hash, status: :created
      else
        render json: { errors: shelf.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { message: "Profile not found" }, status: :not_found
    end
  end

  private

  def get_profile
    @profile = Profile.find_by(id: params[:profile_id])
  end

  def shelf_params
    params.require(:shelf).permit(:title, :description)
  end
end
