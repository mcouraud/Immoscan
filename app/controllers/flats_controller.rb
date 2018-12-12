class FlatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :scraping]

  def index
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
    @flats = @flats.order(price: :desc)
  end

  def scraping
    ScrapingPapJob.perform_later(params.to_json)
    SelogerJob.perform_later(params.to_json)
    ScrapingLogicImmoJob.perform_now(params.to_json)
  end

  def show
    set_flat
  end

  private

  def set_flat
    @flat = Flat.find(params[:id])
  end
end

