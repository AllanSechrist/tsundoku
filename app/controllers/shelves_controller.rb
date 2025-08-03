class ShelvesController < ApplicationController
  before_action :get_profile
  def index
    if @profile
      render json: ShelfSerializer.new(@profile.shelves, include: [:shelf_books, :owned_books]).serializable_hash
    else
      render json: { message: "Profile not found" }, status: :not_found
    end
  end

  private

  def get_profile
    @profile = Profile.find_by(id: params[:profile_id])
  end
end
