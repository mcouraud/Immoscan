require 'open-uri'
require 'nokogiri'
require 'json'
require 'active_support/all'

class ScrapingLogicImmoJob < ApplicationJob
  queue_as :default

  def perform(params)
    logic_immo_scrap_city_id = []
    logic_immo_scrap_level_id = []
    logic_immo_scrap_city_string = []
    logic_immo_flat_url = []
    logic_immo_flat_photo_url = []
    logic_immo_flat_price = []
    logic_immo_flat_city = []
    logic_immo_flat_zipcode = []
    logic_immo_flat_nb_metre_carre = []
    logic_immo_flat_nb_piece = []
    logic_immo_flat_description = []
    logic_immo_final_flat = []
    ad_urls = []

    params = eval(params)

    ville = params[:city]

    logic_immo_url = 'http://www.logic-immo.com/asset/t9/getLocalityT9.php?site=fr&lang=fr&json="' + "#{ville}" + '"'
    json = open(logic_immo_url).read
    logic_immo_json = JSON.parse(json)

    logic_immo_json.each do |element|
      logic_immo_scrap_city_id << element['children'][0]['lct_id']
      break unless logic_immo_scrap_city_id.blank?
    end

    logic_immo_json.each do |element|
      logic_immo_scrap_level_id << element['children'][0]['lct_level']
      break unless logic_immo_scrap_level_id.blank?
    end

    logic_immo_json.each do |element|
      logic_immo_scrap_city_string << element['children'][0]['lct_name']
      break unless logic_immo_scrap_city_string.blank?
    end

    if params[:rent_or_buy] == "louer"
      vente_location = "location"
    else params[:rent_or_buy] == "acheter"
      vente_location = "vente"
    end

    if params[:rent_or_buy] == "louer"
      logic_immo_min_price = 800
    else params[:rent_or_buy] == "acheter"
      logic_immo_min_price = 50000
    end

    logic_immmo_url_recup_annonce = "http://www.logic-immo.com/#{vente_location}-immobilier-#{logic_immo_scrap_city_string.first}-tous-codes-postaux,#{logic_immo_scrap_city_id.first}_#{logic_immo_scrap_level_id.first}/options/groupprptypesids=1,2,7/pricemin=#{logic_immo_min_price}"

    html_file_flat = open(logic_immmo_url_recup_annonce).read
    html_doc_flat = Nokogiri::HTML(html_file_flat)

    html_doc_flat.css(".offer-details-wrapper").uniq.each_with_index do |url, index|
      logic_immo_flat_url << url.children.children.children[1].children[3].attribute('href').value

      logic_immo_scrapping_flat = "#{logic_immo_flat_url[index]}"
      ad_urls << logic_immo_scrapping_flat.remove('http://www.orpi.com/')

      html_file_scrapping_flat = open(logic_immo_scrapping_flat).read
      html_doc_scrap_flat = Nokogiri::HTML(html_file_scrapping_flat)

      html_doc_scrap_flat.css(".col-xs-7 > div:nth-child(1) > p:nth-child(1)").each do |element|
        logic_immo_flat_city << element.text.split(" ").first

      end

      html_doc_scrap_flat.css(".main-price").each do |element|
        logic_immo_flat_price << element.text.remove('€').remove(' ')
      end

      html_doc_scrap_flat.css(".col-xs-7 > div:nth-child(1) > p:nth-child(1)").each do |element|
        if element.text.include?("/")
          logic_immo_flat_zipcode << element.text.split("/").first
        else
          logic_immo_flat_zipcode << element.text.split(" ").last.remove('(').remove(')')
        end
      end

      html_doc_scrap_flat.xpath("/html/body/div[2]/section[1]/div/div[2]/div[1]/div/article/div/header/div[1]/div[2]/p/span[1]").each do |element|
        logic_immo_flat_nb_metre_carre << element.text
        # raise if index > 5
      end

      html_doc_scrap_flat.xpath("/html/body/div[2]/section[1]/div/div[2]/div[1]/div/article/div/header/div[1]/div[2]/p/span[2]/span").each do |element|
        logic_immo_flat_nb_piece << element.text
      end

      flat_photos = []
      html_doc_scrap_flat.xpath("/html/body/div[2]/section[1]/div/div[2]/div[1]/div/article/div/div/section/div[2]/div/div/div/div/ul/li").each do |element|
        if !element.children.children[0].attribute('src').nil?
        flat_photos << element.children.children[0].attribute('src').value
        flat_photos.map {|url| url.gsub!('75x75','800x600') }
        end
      end
      logic_immo_flat_photo_url << flat_photos

      html_doc_scrap_flat.css(".offer-description-text > p:nth-child(3)").each do |element|
        logic_immo_flat_description << element.text
      end
    end

    logic_immo_annonce_total = logic_immo_flat_city.zip(logic_immo_flat_zipcode, logic_immo_flat_price, logic_immo_flat_nb_piece, logic_immo_flat_nb_metre_carre, logic_immo_flat_photo_url, logic_immo_flat_description, ad_urls)

    logic_immo_annonce_total.each_with_index do |flat, index|
      if Flat.find_or_create_by(ad_url: ad_urls[index]) do |element|
        element.city = flat[0].to_s
        element.zipcode = flat[1]
        element.rent_or_buy = params[:rent_or_buy]
        element.price = flat[2].to_i
        element.nb_rooms = flat[3].to_i
        element.surface_housing = flat[4].to_i
        element.photos = flat[5]
        element.description = flat[6]
        element.website_source = "logic-immo.com"
        element.ad_url = "#{ad_urls[index]}"
        element.save!
      end
    end
    end
  end
end

