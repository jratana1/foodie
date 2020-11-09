class User
    attr_accessor :name, :photos, :lefts, :rights

    @@all = []

    def initialize (name)
        @name = name
        @@all << self
    end

    def self.all
        @@all
    end

    def restaurants
        Photo.all.select{|photo| photo.users == self}.map{|photo| photo.restaurant}.uniq
    end
end