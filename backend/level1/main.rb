require 'date'

require_relative '../shared.rb'
require_relative 'functions.rb'

data_hash = convert_hash_data 1

final_rentals = { "rentals" => [] }

data_hash["cars"].each do |car|
	data_hash["rentals"].each do |rental|

		if( car['id'] == rental['car_id'] )

			number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )

			rental_price = rental_price( car, number_rental_days, rental['distance'])

			final_rentals["rentals"].push({ "id" => rental['id'],
																			 "price" => rental_price
																		})
		end
	end
end


File.open("backend/level1/output.json", "wb") { |file| file.puts JSON.pretty_generate( final_rentals ) }