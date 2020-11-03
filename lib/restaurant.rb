class Restaurant
    # attr_accessor :name, :address, :zip_code, :cuisine, :open?, :website, :img_url

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

    def self.all
        @@all
    end

    def self.clear
        @@all = []
    end
end