 class Foodie::CLI

    def call
        
        puts "What would you like to eat?"
        puts "I will get some information and then show you photos in your browser."
        puts "Enter left, right, or exit at each photo."
        puts "Where are you located? (enter zip code or city, state)"
        location = gets.strip
        
        puts "Are there categories (pizza, chinese, mexican, etc) you would like to browse?"
        puts " (may also be left blank)"
        category = gets.strip
        
        if category == ""
            category == "restaurants"
        end
        
        make_restaurants(location, category)
        add_attributes
        add_reviews
       
        input = nil
        
        while input != "exit"          
            rand_rest = rand(30)
            rand_photo = rand(3)
            
            #need to remove restaurants without photos
            open_image(Restaurant.all[rand_rest].photos[rand_photo])
            
            puts "type left or right or reset or exit"
            puts "left : meh"
            puts "right : nom nom nom"
            puts "reset : change location and categories"
            puts "exit : thank you come again"
            puts "----------------------".colorize(:green)
            input = gets.strip

            if input == "right"
                puts "You want to eat at #{Restaurant.all[rand_rest].name}!!!"
                puts "----------------------".colorize(:green)
                puts "#{Restaurant.all[rand_rest].name}".colorize(:blue)
                puts "  location:".colorize(:light_blue) + " #{Restaurant.all[rand_rest].location["display_address"][0]}"
                puts "            #{Restaurant.all[rand_rest].location["display_address"][1]}"
                puts "  telephone:".colorize(:light_blue) + " #{Restaurant.all[rand_rest].display_phone}"
                puts "  rating:".colorize(:light_blue) + " #{Restaurant.all[rand_rest].rating} stars / 5 stars"
                puts "  review:".colorize(:light_blue) + " #{Restaurant.all[rand_rest].reviews[0]["text"]}"
                puts "----------------------".colorize(:green)
            elsif input == "exit"
                exit(0)
            elsif input == "reset"
                puts "----------------------".colorize(:green)
                Restaurant.clear
                self.call
            end
        end

    end

    def open_image(url)
        Launchy.open(url)
    end

     #generate restaurants
    def make_restaurants(location, category)
            restaurants_array = YelpApiAdapter.search(location, category)
            Restaurant.create_from_collection(restaurants_array)
    end
    
    #add more photos
    def add_attributes
        Restaurant.all.each do |restaurant|
            attributes = YelpApiAdapter.business(restaurant.id)
            restaurant.add_restaurant_attributes(attributes)
        end
    end

    #add reviews
    def add_reviews
        Restaurant.all.each do |restaurant|
            attributes = YelpApiAdapter.business_reviews(restaurant.id)
            restaurant.add_restaurant_attributes(attributes)
        end
    end
 end

