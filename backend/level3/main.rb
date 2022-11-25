require_relative '../shared.rb'
require_relative 'functions.rb'


data_hash = convert_hash_data 3

final_rentals_after_commission = { "rentals" => [] }

data_hash["cars"].each do |car|
	data_hash["rentals"].each do |rental|

		if( car['id'] == rental['car_id'] )

			number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
			rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
			commission_from_rental_price = ( rental_price_disc * 30)/100
			final_rentals_after_commission[ "rentals" ].push({
																												"id" => rental['id'],
																												"price" => rental_price_disc,
																												"commission" => {
																																					"insurance_fee": commission_from_rental_price/2,
																																					"assistance_fee": number_rental_days * 100,
																																					"drivy_fee": commission_from_rental_price/2 - number_rental_days * 100
																																				}
												        											})
		end
	end
end


output_json 3, final_rentals_after_commission