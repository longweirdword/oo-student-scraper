require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    noko = Nokogiri::HTML(open(index_url))
    #url = URI.parse(index_url)
    #response = Net::HTTP.get(url)
    #noko = Nokogiri::HTML(response)

    students = noko.css(".student-card").map do |student|
      Hash[:name, student.css(".student-name").text, :location, student.css(".student-location").text, :profile_url, student.css("a").first.attributes["href"].value]
    end 
  end

  def self.scrape_profile_page(profile_url)
    url = URI.parse(profile_url)
    response = Net::HTTP.get(url)
    noko = Nokogiri::HTML(response)

    profile_hash = {}
     noko.css(".vitals-container a").collect do |data|
      link = data.first[1]
      if link.include?("twitter")
        profile_hash[:twitter] = link
      elsif link.include?("linkedin")
        profile_hash[:linkedin] = link 
      elsif link.include?("github")
        profile_hash[:github] = link 
      elsif link != nil 
        profile_hash[:blog] = link 
      end  
    end 

    profile_hash[:profile_quote] = noko.css(".profile-quote").text 
    profile_hash[:bio] = noko.css(".description-holder p").text 
    profile_hash

end

end

