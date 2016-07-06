# Toy City version 2.0 "Toy City 1 with Reviewer Suggestions Incorporated":
# Thanks to my Udacity Toy City 1 reviewer for "brands_all" and "toys_all" functions.

require 'json'
path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)
require 'date'
puts
# Print today's date
puts "Today's Date: #{Date.today}"
puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "
puts

# For each product in the data set:
products_hash["items"].each do |toy|
  # Print the name of the toy
  puts toy["title"]  
  puts "***********************"
  # Full-price is provided in JSON file as a string class
  # For computational purposes, it is converted to a float class
  toy["full-price"] = toy["full-price"].to_f
  # Print the retail price of the toy
  puts "Retail Price: $#{toy["full-price"]}"
  # Calculate and print the total number of purchases
  puts "Total Purchases: #{toy["purchases"].size}"
  # Calculate and print the total amount of sales. Thanks to my code reviewer for the next line.
  totalSales = toy["purchases"].inject(0) { |sales_total, sale| sales_total + sale["price"] }
  puts "Total Sales: $#{totalSales}"
  # Calculate and print the average price the toy sold for
  averagePrice = totalSales/toy["purchases"].size
  puts "Average Price: $#{averagePrice}"
  # Calculate and print the average discount (% or $) based off the average sales price
  averageDiscount = toy["full-price"] - averagePrice
  puts "Average Discount: #{sprintf('$%0.2f',averageDiscount)}"
  puts
end

puts " _                         _     "
puts "| |                       | |    "
puts "| |__  _ __ __ _ _ __   __| |___ "
puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
puts "| |_) | | | (_| | | | | (_| \\__ \\"
puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
puts 

#Thanks to my code reviewer for this version of brands_all.
brands_all = products_hash["items"].map  { |type| type["brand"]}.uniq
brands_all.each do |brand| 
  # Print the name of the brand
  puts 
  puts brand
  puts "*"*30
  by_brand = products_hash["items"].select { |item| item["brand"] == brand}
  brands_toys = by_brand.length
  total_stock = 0
  total_price = 0
  total_revenue = 0

  by_brand.each do |item|
    total_stock += item["stock"]
    total_price += item["full-price"].to_f
    item["purchases"].each do |price|
      total_revenue += price["price"]
    end

  end
  # Print the number of the brand's toys we stock
  puts "Number of products: #{total_stock}"
  # Print the average price of the brand's toys
  puts "Average product price: $#{total_price/brands_toys.round(2)}"
  # Print the total revenue of all the brand's toy sales combined
  puts "Total revenue: $#{(total_revenue).round(2)}"
end

