  require 'open-uri'
  require 'nokogiri'
  require 'json'
  require 'active_support/all'

class ScrapingPapJob < ApplicationJob
  queue_as :default

  def perform(params)
    city_id = []
    city_string = []
    flat_annonce_url = []
    url_flat = []
    pap_flat_price = []
    pap_flat_address = []
    pap_flat_city = []
    pap_flat_zipcode = []
    pap_flat_nb_metre_carre = []
    pap_flat_nb_piece = []
    pap_flat_nb_chambre = []
    pap_flat_photo_url = []
    pap_flat_description = []
    pap_flat_item_date = []

    output = eval(params)

    ville = output[:city]

    if output[:rent_or_buy] == "louer"
      achat_ou_location = "locations"
    else
      achat_ou_location = "vente"
    end

    url_json = "https://www.pap.fr/json/ac-geo?q=#{ville}"
    json = open(url_json).read
    pap_json_parsed = JSON.parse(json)

    pap_json_parsed.each do |element|
      city_id << element['id']
      city_string << element['name'].split(' ').join('-').remove('(').remove(')')
    end

    url_recup_annonce = "https://www.pap.fr/annonce/#{achat_ou_location}-immobiliere-#{city_string.first}-g#{city_id.first}-a-partir-du-studio"

    html_file_recup_annonce = open(url_recup_annonce).read
    html_doc_recup_annonce = Nokogiri::HTML(html_file_recup_annonce)

    html_doc_recup_annonce.search('.search-list-item')[0..5].each do |element|
      flat_annonce_url << element.search('.item-content').search('.item-title').attribute('href').value
    end

    flat_annonce_url.uniq.each_with_index do |url, index|
      url_flat << url

      url_scrapping_flat = "https://www.pap.fr#{url_flat[index]}"

      html_file_flat = open(url_scrapping_flat).read
      html_doc_flat = Nokogiri::HTML(html_file_flat)

      html_doc_flat.search('.item-description').each do |element|
        pap_flat_city  << element.children[3].text.split(' ').first
      end

      html_doc_flat.search('.item-description h2').each do |element|
        pap_flat_zipcode  << element.text.split(' ').last.remove(')').remove('(')
      end

      html_doc_flat.search('.item-price').each do |element|
        pap_flat_price << element.text.remove('.').remove('€')
      end

      # html_doc_flat.search('.item-price').each do |element|
      # pap_flat_address = [] << element.text

      html_doc_flat.search('.item-tags li:last-child').each do |element|
        pap_flat_nb_metre_carre << element.text.remove('m²')
      end

      html_doc_flat.search('.item-tags').each do |element|
        pap_flat_nb_piece << element.children[1].text.remove('pièce')
      end

      html_doc_flat.search('.item-tags').each do |element|
        pap_flat_nb_chambre << element.children[3].text.remove('chambre')
      end

      flat_photos = []
      html_doc_flat.search('.img-liquid').each do |element|
        flat_photos << element.children[1].attribute('src').value
      end
      pap_flat_photo_url << flat_photos


      html_doc_flat.search('.item-description').each do |element|
        pap_flat_description << element.children.children.children.text
      end

      html_doc_flat.search('.item-date').each do |element|
        pap_flat_item_date << element.text
      end
    end

    pap_annonce_total = pap_flat_city.zip( pap_flat_zipcode, pap_flat_price, pap_flat_nb_piece, pap_flat_nb_chambre, pap_flat_nb_metre_carre, pap_flat_photo_url, pap_flat_description, pap_flat_item_date, url_flat)

    pap_annonce_total.each_with_index do |flat, index|
      if Flat.find_or_create_by(ad_url: "https://www.pap.fr#{url_flat[index]}") do |element|
        element.city = flat[0].to_s
        element.zipcode = flat[1]
        element.rent_or_buy = output[:rent_or_buy]
        element.price = flat[2].to_i
        element.nb_rooms = flat[3].to_i
        element.nb_bedrooms = flat[4].to_i
        element.surface_ground = flat[5].to_i
        element.photos = flat[6]
        element.description = flat[7]
        element.website_source = "pap.fr"
        element.ad_url = "https://www.pap.fr#{url_flat[index]}"
        element.save!
      end
    end
  end
end
end
