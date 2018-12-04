class SearchesController < ApplicationController
  def index
  end

  def create

    redirect_to searches_path
  end
end
