require "pry-byebug"

class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:city_query].present?  && params[:price_query].present? && params[:nb_rooms_query].present?
      @flats = Flat.where('city ILIKE ?', params[:city_query]).where('price <= ?', params[:price_query].to_i).where('nb_rooms = ?', params[:nb_rooms_query].to_i)
    elsif params[:city_query].present?  && params[:price_query].present?
      @flats = Flat.where('city ILIKE ?', params[:city_query]).where('price <= ?', params[:price_query].to_i)
    elsif params[:city_query].present?
      @flats = Flat.where('city ILIKE ?', params[:city_query])
    end
  end

  def show
  end
end
