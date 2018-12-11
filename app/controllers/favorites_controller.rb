class FavoritesController < ApplicationController
  def index
    @favorites = Favorite.select { |favorite| favorite.user == current_user }
  end

  def create
    @flat = Flat.find(params[:flat_id])
    @favorite = Favorite.new
    @favorite.user = current_user
    @favorite.flat = @flat
    @favorite.save
    redirect_back fallback_location: favorites_path
  end
end
