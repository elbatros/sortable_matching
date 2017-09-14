require 'json'

products = Array.new
product_items = File.open('products.txt', 'r').each_line.map { |l| 
	item = JSON.parse(l)

	item["product_name_strings"] = item["product_name"].split(/[\s_]/)
	item["listings"] = Array.new

	products.push(item)
}


listings_items = File.open('listings.txt', 'r').each_line.map { |l| 
	item = JSON.parse(l)
	products.each do |product|
		if product["product_name_strings"].all? {|p| item["title"].match(/(^|\s)#{p}(\s|$)/)}
			product["listings"].push(item)
		end
	end
}

open('results.txt', 'w'){ |f|
	products.each do |pro|
		f.puts pro.tap { |k|
			k.delete("manufacturer")
			k.delete("currency")
			k.delete("price")
			k.delete("product_name_strings")
			k.delete("announced-date")
			k.delete("model")
			k.delete("family")
		}.to_json
	end
}
