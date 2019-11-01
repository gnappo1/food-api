require 'pry'
require 'httparty'
require 'net/http'

class Recipe
    attr_accessor :href
    attr_reader :title, :ingredients
    BASE_URL = "http://www.recipepuppy.com/api/?"
    @@all_recipes = []

    def initialize(title, href, ingredients)
        @title, @href, @ingredients = title, href, ingredients
        save
    end

    def save
        @@all_recipes << self
    end

    def self.get_recipes_by_ingredient(ingredient)
        uri = URI("#{BASE_URL}i=#{ingredient}")
        response = Net::HTTP.get(uri)

        res_json = JSON(response)
        return res_json["results"]

    end

    def self.create_recipes_from_list(ingredient)
        recipes_list = get_recipes_by_ingredient(ingredient)
        recipes_list.each do |recipe|
            new(recipe["title"], recipe["href"], recipe["ingredients"])
        end
        self.show_recipes
    end

    def self.all_recipes
        @@all_recipes
    end

    def self.user_input_call_get_recipes
        puts "Please enter ingredient name:"
        input = gets.chomp
        string = input.gsub(" ", ", ")
        self.create_recipes_from_list(string)
    end

    def self.show_recipes
        #binding.pry
        puts "Here is the list of recipes:"
        all_recipes.each do |recipe|
          puts "\e[32m Recipe: #{recipe.title.strip;} | Ingredients: #{recipe.ingredients.strip}\e[0m"
        end
    end

end

Recipe.user_input_call_get_recipes
