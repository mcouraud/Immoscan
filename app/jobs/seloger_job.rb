require 'open-uri'
require 'nokogiri'
require 'active_support/all'

class SelogerJob < ApplicationJob
  queue_as :default

  def perform(params)
    injection = City.where('name ILIKE ?', params[:city]).ci

    if params[:rent_or_buy] == "louer"
      injection << "&idtt=1"
    else
      injection << "&idtt=2"
    end

    baseUrl = "http://ws.seloger.com/search.xml?#{injection}"
    doc = Nokogiri::XML(open("#{baseUrl}"))
    annonces = doc.xpath("//recherche//annonces//annonce")

    pageSuivante = doc.xpath("//recherche//pageSuivante")[0].to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')

    if pageSuivante == ""
      annonces.map do |item|
        item.at_xpath(".//prix").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//descriptif").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//latitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//longitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//ville").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//codeInsee").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//cp").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//surface").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbPiece").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbChambre").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbPiece").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.xpath(".//photos").each do |photo|
          photo.xpath(".//photo/stdUrl").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '').split('https://').reject { |item| item.nil? || item == '' }
        end
      end
    else
      annonces.map do |item|
        item.at_xpath(".//prix").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//descriptif").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//latitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//longitude").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//ville").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//codeInsee").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//cp").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//surface").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbPiece").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbChambre").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.at_xpath(".//nbPiece").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '')
        item.xpath(".//photos").each do |photo|
          photo.xpath(".//photo/stdUrl").to_s.gsub(/<[a-zA-Z\/][^>]*>/, '').split('https://').reject { |item| item.nil? || item == '' }
        end
      end
      baseUrl = pageSuivante
    end
    # Do something later
  end
end
