class OwnedBooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owned_book, only: [:show]

  def index
    render json: OwnedBookSerializer.new(current_user.owned_books).serializable_hash
  end

  def show
    render json: OwnedBookSerializer.new(@owned_book, include: [:book]).serializable_hash
  end

  private

  def set_owned_book
    @owned_book = current_user.owned_books.find_by(id: params[:id])
    render json: { error: "OwnedBook now found" }, status: :not_found unless @owned_book
  end
end
