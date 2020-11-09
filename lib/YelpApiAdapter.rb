require "json"
require "http"
require "optparse"
API_HOST = "https://api.yelp.com"
SEARCH_PATH = "/v3/businesses/search"
BUSINESS_PATH = "/v3/businesses/"
SEARCH_LIMIT = 50
API_KEY = "w6qa8__4fH9T6fuiTpxA09hBfrKhosMvhe9N4EVtpZ6GaqJpTTasxnDkgApBCtGUGbiO9VinV1x4nU9VhVeMLepRZa1CZdHpK-o33NtvPj2LsFag44iGgPMqkx6eX3Yx"

class YelpApiAdapter
    
    def self.search(location, categories = "restaurants", offset = 1)
      url = "#{API_HOST}#{SEARCH_PATH}"
      params = {
        term: "food",
        categories: categories,
        location: location,
        limit: SEARCH_LIMIT,
        offset: offset
      }
      response = HTTP.auth("Bearer #{API_KEY}").get(url, params: params)
      response.parse["businesses"]
    end
  
    def self.business_reviews(business_id)
      url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}/reviews"
      response = HTTP.auth("Bearer #{API_KEY}").get(url)
      response.parse
      # response.parse["reviews"]
    end
    
    def self.business(business_id)
      url = "#{API_HOST}#{BUSINESS_PATH}#{business_id}"
      response = HTTP.auth("Bearer #{API_KEY}").get(url)
      response.parse
    end
    
  end