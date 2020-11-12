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

            open_image(rand_photo.url)
            swipe(user, rand_photo, location, category, offset)
        end

    end

    def open_image(url)
        Launchy.open(url)
    end

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

    def swipe(user, rand_photo, location, category, offset)
        rand_rest = rand_photo.restaurant
        puts "type left or right or reset or exit"
        puts "left  : Meh..."
        puts "right : Nom nom nom!!!"
        puts "reset : Change location and categories"
        puts "more  : I want more!!!!"
        puts "show  : Let me see what I got."
        puts "exit  : Thank you come again"
        puts "----------------------".colorize(:green)

        input = gets.strip
        case input
        when "right"
            rand_photo.swipe_right(user)
            
            puts "You want to eat at #{rand_rest.name}!!!"
            puts "----------------------".colorize(:green)
            puts "#{rand_rest.name}".colorize(:blue)
            puts "  location:".colorize(:light_blue) + " #{rand_rest.location["display_address"][0]}"
            puts "            #{rand_rest.location["display_address"][1]}"
            puts "  telephone:".colorize(:light_blue) + " #{rand_rest.display_phone}"
            puts "  rating:".colorize(:light_blue) + " #{rand_rest.rating} stars / 5 stars with #{rand_rest.review_count} reviews"
            puts "  review:".colorize(:light_blue) + " #{rand_rest.reviews[0]["text"]}"
            puts "----------------------".colorize(:green)
            puts "Hit Enter to Keep Swiping"
            gets.strip
        when "exit"          
            user.restaurants.each do |restaurant|
                puts "----------------------".colorize(:green)
                puts "#{restaurant.name}".colorize(:blue)
                puts "  location:".colorize(:light_blue) + " #{restaurant.location["display_address"][0]}"
                puts "            #{restaurant.location["display_address"][1]}"
                puts "  telephone:".colorize(:light_blue) + " #{restaurant.display_phone}"
                puts "----------------------".colorize(:green)
                end
            puts "See you later!" 
            
            exit(0)
        when "reset"
            puts "----------------------".colorize(:green)
            #want to be able to reset without clearing restaurants, 
            #need to call a photo by city and category and then random so I can keep all photos and restaurants
            Restaurant.clear
            offset = 1
            location = ask_for_location
            category = ask_for_category
            pull_rest_and_photos(location, category, offset)
        when "more"
            offset += 50
            pull_rest_and_photos(location, category, offset)
        when "left"
            rand_photo.swipe_left
            puts "----------------------".colorize(:green)
            puts "Check this out instead!"
        when "show"
            user.restaurants.each do |restaurant|
                puts "----------------------".colorize(:green)
                puts "#{restaurant.name}".colorize(:blue)
                puts "  location:".colorize(:light_blue) + " #{restaurant.location["display_address"][0]}"
                puts "            #{restaurant.location["display_address"][1]}"
                puts "  telephone:".colorize(:light_blue) + " #{restaurant.display_phone}"
                puts "----------------------".colorize(:green)
                end
        else
            puts "----------------------".colorize(:green)
            puts "I don't understand."
            swipe(rand_rest, rand_photo, location, category, offset)
        end
    end
 end