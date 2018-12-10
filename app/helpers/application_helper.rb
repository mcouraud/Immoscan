require 'open-uri'
require 'nokogiri'
require 'json'
require 'active_support/all'

module ApplicationHelper
  def scraping_pap

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

    puts 'dans quelle ville cherchez vous ?'

    ville = gets.chomp

    puts "'vente', 'locations' (tapez exactement un des choix) ?"

    achat_ou_location = gets.chomp

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
      flat_annonce_url << element.children.children.children.children[14].attribute('href').value
    end

    flat_annonce_url[0..20].uniq.each do |url|
      url_flat << url

      url_scrapping_flat = "https://www.pap.fr#{url_flat.last}"

      html_file_flat = open(url_scrapping_flat).read
      html_doc_flat = Nokogiri::HTML(html_file_flat)

      html_doc_flat.search('.item-description').each do |element|
        pap_flat_city  << element.children[3].text
      end

      html_doc_flat.search('.item-price').each do |element|
        pap_flat_price << element.text
      end

      # html_doc_flat.search('.item-price').each do |element|
      # pap_flat_address = [] << element.text


      # html_doc_flat.search('.item-price').each do |element|
      #   pap_flat_zipcode = [] << element.text  end

      html_doc_flat.search('.item-tags').each do |element|
        pap_flat_nb_metre_carre << element.children[5].text
      end

      html_doc_flat.search('.item-tags').each do |element|
        pap_flat_nb_piece << element.children[1].text
      end

      html_doc_flat.search('.item-tags').each do |element|
        pap_flat_nb_chambre << element.children[3].text
      end

      html_doc_flat.search('.img-liquid').each do |element|
        pap_flat_photo_url << element.children[1].attribute('src')
      end

      html_doc_flat.search('.item-description').each do |element|
        pap_flat_description << element.children.children.children.text
      end

      html_doc_flat.search('.item-date').each do |element|
        pap_flat_item_date << element.text
    end
  end

  pap_annonce_total = pap_flat_city.zip(pap_flat_price, pap_flat_nb_piece, pap_flat_nb_chambre, pap_flat_nb_metre_carre, pap_flat_photo_url, pap_flat_description, pap_flat_item_date)

  pap_annonce_total.each do |element|
    puts element
  end
end
end
