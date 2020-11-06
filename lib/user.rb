class User
    attr_accessor :name, :photos, :lefts, :rights

    @@all = []

    def initialize (name)
        @name = name
        @restaurants = []
        @photos = []
        @lefts = 0
        @rights = 0
        @@all << self
    end

end