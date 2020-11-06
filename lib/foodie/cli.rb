 class Foodie::CLI

    def call
        puts "Welcome, tell me your name."
        name = gets.strip
        user = User.new(name)
        puts "Hi, #{name}!  What would you like to eat?"
        
        offset = 1
        location = ask_for_location
        category = ask_for_category
        pull_rest_and_photos(location, category, offset)
        
        input = nil
        while input != "exit"                             
            #need to pull photo by photo.restaurant.city  or zipcode == location
            rand_photo = Photo.all[rand(Photo.all.length)]
            rand_rest = rand_photo.restaurant

            open_image(rand_photo.url)
            swipe(rand_rest, rand_photo, location, category, offset)
        end

    end

    def open_image(url)
        Launchy.open(url)
    end

    #generate restaurants
    def make_restaurants(location, category, offset = 1)
            restaurants_array = YelpApiAdapter.search(location, category, offset)
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

    def pull_rest_and_photos(location, category, offset)
        make_restaurants(location, category, offset)
        add_attributes
        add_reviews
        Restaurant.create_photos_restaurants
        Photo.add_restaurants_by_id
    end

    def ask_for_location
        puts "Where are you located? (enter zip code or city, state)"
        location = gets.strip
    end

    def ask_for_category
        puts "Are there categories (pizza, chinese, mexican, etc) you would like to browse?"
        puts " (may also be left blank)"
        category = gets.strip
        
        if category == ""
            category = "restaurants"
        end
        category
    end

    def swipe(rand_rest, rand_photo, location, category, offset)
        puts "type left or right or reset or exit"
        puts "left  : Meh..."
        puts "right : Nom nom nom!!!"
        puts "reset : Change location and categories"
        puts "more  : I want more!!!!"
        puts "exit  : Thank you come again"
        puts "----------------------".colorize(:green)

        input = gets.strip

        if input == "right"
            rand_photo.swipe_right
            user.restaurants << rand_rest
            puts "You want to eat at #{rand_rest.name}!!!"
            puts "----------------------".colorize(:green)
            puts "#{rand_rest.name}".colorize(:blue)
            puts "  location:".colorize(:light_blue) + " #{rand_rest.location["display_address"][0]}"
            puts "            #{rand_rest.location["display_address"][1]}"
            puts "  telephone:".colorize(:light_blue) + " #{rand_rest.display_phone}"
            puts "  rating:".colorize(:light_blue) + " #{rand_rest.rating} stars / 5 stars"
            puts "  review:".colorize(:light_blue) + " #{rand_rest.reviews[0]["text"]}"
            puts "----------------------".colorize(:green)
            puts "Hit Enter to Keep Swiping"
            gets.strip
        elsif input == "exit"
            puts "----------------------".colorize(:green)
            puts "See you later...user data like restaurants liked" 
            binding.pry
            exit(0)
        elsif input == "reset"
            puts "----------------------".colorize(:green)
            Restaurant.clear
            offset = 1
            location = ask_for_location
            category = ask_for_category
            pull_rest_and_photos(location, category, offset)
        elsif input == "more"
            offset += 50
            pull_rest_and_photos(location, category, offset)
        elsif input == "left"
            rand_photo.swipe_left
            puts "----------------------".colorize(:green)
            puts "Check this out instead!"
        else
            puts "----------------------".colorize(:green)
            puts "I don't understand."
            swipe(rand_rest, rand_photo, location, category, offset)
        end
    end
 end