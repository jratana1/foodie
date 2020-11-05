class Photo
    attr_accessor :url, :restaurant, :rest_id
    # attr_reader :restaurant, :id
    @@all = []

    # def id= (id)
    #     restaurant = Restaurant.find_or_create_by_id(id)
    #     self.restaurant = restaurant   
    # end

    def initialize (url, rest_id = nil)
        @url = url
        @rest_id = rest_id
        @@all << self
    end
     
    def self.all
        @@all
    end
    
    def self.add_restaurants_by_id
        self.all.each {|photo| photo.restaurant = Restaurant.all.select {|restaurant| restaurant.id == photo.rest_id}[0]}
    end

    def find_rest_by_photo_id
        Restaurant.all.select {|restaurant| restaurant.id == self.rest_id}
    end

    #swipe_counter
    #
    #end
end