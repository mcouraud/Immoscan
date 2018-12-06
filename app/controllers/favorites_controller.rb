class FavoritesController < ApplicationController
  def index
    @flats = current_user.flat
  end

  def create
  end
end
