# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'open-uri'
require 'nokogiri'
require 'json'

puts "dans quelle ville cherchez vous ?"

ville = gets.chomp

url = "https://www.pap.fr/json/ac-geo?q=#{ville}"
json = open(url).read
pap_url_id = JSON.parse(json)

id_url = []
city_string = []

pap_url_id.each do |element|
  id_url << element["id"]
  city_string << element["name"].split(" ").join("-").remove("(").remove(")")
end

url = "https://www.pap.fr/annonce/vente-immobiliere-#{city_string.first}-g#{id_url.first}-a-partir-du-studio"

html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)

titre_annonce = []
html_doc.search('.h1').each do |element|
  titre_annonce << element.text
end

prix_annonce = []
html_doc.search('.item-price').each do |element|
  prix_annonce << element.text
end

flat_photo_count = []
html_doc.search('.item-photo-count').each do |element|
  flat_photo_count << element.text
end

flat_description = []
html_doc.search('.item-description').each do |element|
  flat_description << element.text
end

flat_item_date = []
html_doc.search('.item-date').each do |element|
  flat_item_date << element.text
end

flat_nb_piece = []
html_doc.search('.item-tags')[0..5].each do |element|
  flat_nb_piece << element.children[1].children.children
end

flat_nb_chambre = []
html_doc.search('.item-tags')[0..5].each do |element|
  flat_nb_chambre << element.children[3].children.children
  # if tmp.find { |string| string == "chambre"}
  #   flat_nb_chambre << tmp
  # else tmp.find { |string| string == "m2"}
  #   flat_nb_metre_carre << tmp
  # end
end

flat_nb_metre_carre = []
html_doc.search('.item-tags')[0..5].each do |element|
  flat_nb_metre_carre << element.children[5].children.children.text
  puts flat_nb_metre_carre
end

flat_url = []
html_doc.search('.item-title')[0..5].each do |element|
  flat_url << element.attribute('href').value
end

annonce_total = titre_annonce.zip(prix_annonce, flat_photo_count, flat_description, flat_item_date, flat_nb_piece, flat_nb_chambre, flat_nb_metre_carre, flat_url)

annonce_total[0..5].each do |element|
  puts element
end

# p flat_nb_pieces.children[1].children.children.to_s
# p flat_nb_pieces.children.class_name
