# Version 2.2: Easy To Read
# In this version:
# Functions named "print" output strings.
# Functions named "create" call "print" functions
# Thanks to my udacity Toy City I reviewer for functions "brands_all" and "toys_all".

# Reviewer: Please see version (v2.3 "Simple") in my previous github commit. 

require 'json'
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
end
def retail_price(toy)
  retail_price = toy["full-price"].to_f
end
def purchases_count(toy, purchases_count = 0)
  purchases_count = toy["purchases"].count
end
def total_sales(toy)
  total_sales = toy["purchases"].inject(0){|total, sale| total + sale["price"]}
end
def average_product_sale(toy, average_product_sale = 0)
  average_product_sale = total_sales(toy)/purchases_count(toy)
end
def average_discount(toy, average_discount = 0)
  average_discount = retail_price(toy) - average_product_sale(toy)
end
def toys_all(brand)
  toys_all = $products_hash["items"].select {|toy| toy["brand"] == brand}
end
def total_stock(brand)
  total_stock = toys_all(brand).inject(0){|total,toy|total+toy["stock"]}
end
def toys_count(brand)
  toys_count = toys_all(brand).length
end
def total_revenue(brand, total_revenue = 0)
  total_revenue = toys_all(brand).inject(0){|total,toy|total + total_sales(toy)}
end
def total_retail_prices(brand)
  total_retail_prices = toys_all(brand).inject(0){|total, toy| total + retail_price(toy)}
end
def retail_price_average(brand, price_average = 0)
  retail_price_average = total_retail_prices(brand)/toys_count(brand)
end
def brands_all()
  brands_all = $products_hash["items"].map{ |type| type["brand"]}.uniq
end
def print_heading(heading)
  require 'artii'
  heading_ascii = Artii::Base.new
  $report_file.puts "#{heading_ascii.asciify(heading)}\n"
end
def print_date
  $report_file.puts "Report made #{Time.now.strftime("%m/%d/%y")}\n"
end
def print_one_brand(brand)
  $report_file.puts "#{brand}"
  $report_file.puts "*"*30
  $report_file.puts "Number of Products: #{total_stock(brand)}"
  $report_file.puts "Average Product Price: #{sprintf('$%0.2f',retail_price_average(brand))}"
  $report_file.puts "Total Revenue: #{sprintf('$%0.2f', total_revenue(brand))}"
  $report_file.puts
end
def print_one_product(toy)
  $report_file.puts toy["title"]
  $report_file.puts "*"*30
  $report_file.puts "Retail Price: #{sprintf('$%0.2f',retail_price(toy))}"
  $report_file.puts "Total Purchases: #{purchases_count(toy)}"
  $report_file.puts "Total Sales: #{sprintf('$%0.2f', total_sales(toy))}"
  $report_file.puts "Average Price: #{sprintf('$%0.2f',average_product_sale(toy))}"
  $report_file.puts "Average Discount: #{sprintf('$%0.2f',average_discount(toy))}"
  $report_file.puts
end
def create_products()
  print_heading("Products")
  $products_hash["items"].each {|toy| print_one_product(toy)}
end
def create_brands()
  print_heading("Brands")
  brands_all().each {|brand| print_one_brand(brand)}
end
def create_sections()
  create_products()
  create_brands()
end
def create_report(options = {})
  heading = options[:title] ||"Sales Report" 
  print_heading(heading) 
  print_date() 
  create_sections()
end
#start accepts an optional sales report title as {title: "<title>"}
def start()
  setup_files
  create_report({title: "Sales Report"})
  $report_file.close
  puts "Report created in ./report.txt."
end
start()

