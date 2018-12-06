class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    ScrapingPapJob.perform_now(params)
    if params[:city].present?  && params[:price].present? && params[:nb_rooms].present? && params[:rent_or_buy].present?
      @flats = Flat.where('city ILIKE ?', params[:city]).where('price <= ?', params[:price].to_i).where('nb_rooms = ?', params[:nb_rooms].to_i).where('rent_or_buy ILIKE ?', params[:rent_or_buy])
    elsif params[:city].present?  && params[:price].present? && params[:rent_or_buy].present?
      @flats = Flat.where('city ILIKE ?', params[:city]).where('price <= ?', params[:price].to_i).where('rent_or_buy ILIKE ?', params[:rent_or_buy])
    elsif params[:city].present? && params[:rent_or_buy].present?
      @flats = Flat.where('city ILIKE ?', params[:city]).where('rent_or_buy ILIKE ?', params[:rent_or_buy])
    else
      flash[:alert] = "Veuillez choisir une localisation"
      redirect_to root_path
    end
  end

  def show
  end
end
