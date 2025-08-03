class OwnedBooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owned_book, only: [:show, :update, :destroy]

  def index
    render json: OwnedBookSerializer.new(current_user.owned_books).serializable_hash
  end

  def show
    render json: OwnedBookSerializer.new(@owned_book, include: [:book]).serializable_hash
  end

  def create
    owned_book = current_user.owned_books.new(owned_book_params)
    if owned_book.save
      render json: OwnedBookSerializer.new(owned_book, include: [:book]).serializable_hash, status: :created
    else
      render json: { errors: owned_book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    owned_book = current_user.owned_books.find_by(id: params[:id])
    return render json: { error: "OwnedBook not found" }, status: :not_found unless owned_book

    if owned_book.update(owned_book_params)
      render json: OwnedBookSerializer.new(owned_book, include: [:book]).serializable_hash, status: :ok
    else
      render json: { errors: owned_book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    owned_book = current_user.owned_books.find_by(id: params[:id])
    return render json: { error: "OwnedBook not found" }, status: :not_found unless owned_book

    if owned_book.destroy
      render json: { message: "Book was successfully deleted." }, status: :ok
    else
      render json: { errors: owned_book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_owned_book
    @owned_book = current_user.owned_books.find_by(id: params[:id])
    render json: { error: "OwnedBook not found" }, status: :not_found unless @owned_book
  end

  def owned_book_params
    params.require(:owned_book).permit(:book_id, :rating, :review)
  end
end
