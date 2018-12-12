require 'open-uri'
require 'nokogiri'
require 'active_support/all'

class SelogerJob < ApplicationJob
  queue_as :default

  def perform(params)

    params = eval(params)
#  recuperation des params de la query
    city_query = City.select { |m| m.name.downcase == params[:city].downcase }

    injection = "&ci=" + city_query[0].ci
    if params[:rent_or_buy] == "louer"
      injection += "&idtt=1"
    else
      injection += "&idtt=2"
    end

# variables de l'appartement a creer
    flat_price = []
    flat_address = []
    flat_city = []
    flat_zipcode = []
    flat_nb_metre_carre = []
    flat_nb_piece = []
    flat_nb_chambre = []
    flat_photo_url = []
    flat_description = []
    flat_item_date = []
    flat_url = []

# debut du scrapping
# section de parametrages de l url
      baseUrl = "http://ws.seloger.com/search.xml?#{injection}"
      doc = Nokogiri::XML(open("#{baseUrl}"))
      annonces = doc.xpath("//recherche//annonces//annonce")

      pageSuivante = doc.xpath("//recherche//pageSuivante")[0].to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
      annonces.map do |item|
        flat_price << item.at_xpath(".//prix").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_url << item.at_xpath(".//permaLien").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_description << item.at_xpath(".//descriptif").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//latitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//longitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_city << item.at_xpath(".//ville").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '').split.first
        item.at_xpath(".//codeInsee").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_zipcode << item.at_xpath(".//cp").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_nb_metre_carre << item.at_xpath(".//surface").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_nb_piece << item.at_xpath(".//nbPiece").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        flat_nb_chambre << item.at_xpath(".//nbChambre").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.xpath(".//photos").each do |photo|
          flat_photo_url << photo.xpath(".//photo/stdUrl").to_s.gsub(/<[a-zA-Z\/][^>]*>/, ' ').split(' ').reject { |item| item.nil? || item == '' }

        end
      end
      baseUrl = pageSuivante

    annonce_total = flat_city.zip(flat_zipcode, flat_price, flat_nb_piece, flat_nb_chambre, flat_nb_metre_carre, flat_photo_url, flat_description, flat_url)

    annonce_total.each_with_index do |flat, index|
      puts Flat.find_or_create_by(ad_url: flat_url[index]).inspect
      if Flat.find_or_create_by(ad_url: flat_url[index]) do |element|
        element.city = flat[0].to_s
        element.zipcode = flat[1]
        element.rent_or_buy = params[:rent_or_buy]
        element.price = flat[2].to_i
        element.nb_rooms = flat[3].to_i
        element.nb_bedrooms = flat[4].to_i
        element.surface_housing = flat[5].to_i
        element.photos = flat[6]
        element.description = flat[7]
        element.website_source = "seloger.com"
        element.ad_url = "#{flat_url[index]}"
        element.save!
      end
      end
    end
  end
end
