class Restaurant

    @@all = []

    def initialize(restaurants_hash)
        restaurants_hash.each do |key, value| 
          self.class.attr_accessor(key)
          self.send(("#{key}="), value)
        end
        @@all << self
    end
    
    def self.create_from_collection(restaurants_array)
      restaurants_array.each {|restaurant| Restaurant.new(restaurant)}
    end

    def add_restaurant_attributes(attributes_hash)       
        attributes_hash.each do |key, value| 
            self.class.attr_accessor(key)
            self.send(("#{key}="), value)
        end
        self
    end

    #make photos from url and bus_id in restaurants, clear photos attr. from rest.
    def self.create_photos_restaurants
        self.all.each do |restaurant| 
            restaurant.photos.each do |url|
                Photo.new(url, restaurant.id)
                end
            end
    end

    def rest_photo_objects
        Photo.all.select {|photo| photo.restaurant == self}
    end

    def self.all
        @@all
    end

    def self.clear
        @@all = []
    end
end