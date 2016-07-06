# Toy City version 2.1 "Makes Output Hash":
# A hash is built to collect sales report_data by functions named "create" (see end comments).
# The sales_data hash is converted to strings for output by functions named "print".
# Output strings are merged into one sales_report string by make_report().
# The sales_report is printed to report.txt by start().
# Thanks to my Udacity Toy City 1 reviewer for "brands_all" and "toys_all" functions.

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
def create_one_brand(brand)
  { "Brand" => brand, 
    "Number of Products" => total_stock(brand),
    "Average Product Price" => sprintf('$%0.2f',retail_price_average(brand)),
    "Total Revenue" => sprintf('$%0.2f', total_revenue(brand))
  }
end
def create_one_product(toy)
  { "product" => toy["title"], 
    "Retail Price" => sprintf('$%0.2f',retail_price(toy)),
    "Total Purchases" => purchases_count(toy),
    "Total Sales" => sprintf('$%0.2f', total_sales(toy)),
    "Average Price" => sprintf('$%0.2f',average_product_sale(toy)),
    "Average Discount" => sprintf('$%0.2f',average_discount(toy))
  }
end
def create_products()
  section_hash = {section_heading: "Products",  section_data: []}
  $products_hash["items"].each do |toy|
    section_hash[:section_data].push(create_one_product(toy))
  end
  return section_hash
end
def create_brands()
  section_hash = {section_heading: "Brands",  section_data: []}
  brands_all().each do |brand|
    section_hash[:section_data].push(create_one_brand(brand))
  end
  return section_hash
end
def create_sales_data()
  sales_data = {:sections => []}
  sales_data[:sections].push(create_products())
  sales_data[:sections].push(create_brands())
  return sales_data
end
def print_heading(heading)
  require 'artii'
  heading_ascii = Artii::Base.new
  return "\n#{heading_ascii.asciify(heading)}\n"
end
def print_date
  date = Time.now.strftime("%m/%d/%y")
  return "Report made #{date}\n"
end
def print_section_data(section)
  section_output = ""
  section[:section_data].each do |item|
    section_output << "#{(item.shift[1])}\n#{"*"*30}\n)"
    item.each_pair {|name, value| section_output<<"#{name}: #{value}\n"}
  end
  return section_output
end
def print_sections(sales_data)
  sections_output = ""
  sales_data[:sections].each do |section|
    sections_output << print_heading(section[:section_heading])
    sections_output << print_section_data(section)
  end
  return sections_output
end
def make_report(options = {})
  heading = options[:title] ||"Sales Report" 
  sales_data = create_sales_data()
  sales_report = print_heading(heading) + print_date() + print_sections(sales_data)
  return sales_report
end
#make_report() accepts an optional sales report title as {title: "<title>"}
def start()
  setup_files()
  sales_report = make_report()
  $report_file.puts sales_report
  puts "Report printed to ./report.txt"
end
start()

=begin
sales_data structure: 
sales_data = {
  sections: [
    {section_heading: "<section_name>",
    section_data: {
      "item" => "<value>"
      }
    }
  ]
}
=end


