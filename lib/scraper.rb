require 'open-uri'
require 'nokogiri'
require 'pry'


class Scraper

  def self.scrape_index_page(index_url)
     html = File.read("./fixtures/student-site/index.html")
     doc = Nokogiri::HTML(html)
     list_students = []
     students = {}
     doc.css(".student-card").each {|a| 
     students = {
       :name => a.css(".student-name").text,
       :location => a.css(".student-location").text,
       :profile_url => a.css("a").attr("href").value
     }
     list_students << students
     }
     list_students
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    doc = Nokogiri::HTML(html)
    profile = {}
    social_media = doc.css(".social-icon-container").css("a")
    social_media.each do |link| 
  
    if link.attr("href").include?("twitter")
      profile[:twitter] = link.attr("href")
    end
    if link.attr("href").include?("linkedin")
      profile[:linkedin] = link.attr("href")
    end
    if link.attr("href").include?("github")
      profile[:github] = link.attr("href")
    end
    unless link.attr("href").include?("twitter") || link.attr("href").include?("github") || link.attr("href").include?("linkedin")
      profile[:blog] = link.attr("href")
    end
    
    end
      profile[:profile_quote] = doc.css(".profile-quote").text
      profile[:bio] = doc.css(".description-holder").first.text.strip
      profile
  end
end