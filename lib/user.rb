class User
    attr_accessor :name, :restaurants, :lefts, :rights

    @@all = []

    def initialize (name)
        @name = name
        @restaurants = []
        @lefts = 0
        @rights = 0
        @@all << self
    end


end