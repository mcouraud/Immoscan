class FavoritesController < ApplicationController
  def index
  end

  def create
    redirect_to flats_path(params...)
  end
end
