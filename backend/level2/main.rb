require_relative '../shared.rb'
require_relative 'functions.rb'

data_hash = convert_hash_data 2

final_rentals_after_discount = { "rentals" => [] }

data_hash["cars"].each do |car|
	data_hash["rentals"].each do |rental|

		if( car['id'] == rental['car_id'] )
			number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
			rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
			final_rentals_after_discount["rentals"].push({ "id" => rental['id'],
														   											 "price" => rental_price_disc
																									})
		end
	end
end

output_json 2, final_rentals_after_discount