require_relative '../shared.rb'
require_relative 'functions.rb'


data_hash = convert_hash_data 5

final_rentals_after_commission = { "rentals" => [] }

data_hash["cars"].each do |car|

	data_hash["rentals"].each do |rental|
		options = []
		gps =  0
		baby_seat = 0
		additional_insurance = 0
		data_hash['options'].each do |opt|
			if( car['id'] == rental['car_id'] )
				if rental['id'] == opt['rental_id']
					options.push opt['type']
				end
			end
		end
		number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
		if options.include?("gps")
			gps = 500 * number_rental_days
		end
		if options.include?("baby_seat")
			baby_seat = 200 * number_rental_days
		end
		if options.include?("additional_insurance")
			additional_insurance = 1000 * number_rental_days
		end

		rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
		commission_from_rental_price = ( rental_price_disc * 30)/100
		final_rentals_after_commission[ "rentals" ].push({
																				"id" => rental['id'],
																				"options" => options,
																				"actions" => [{
																						"who" => "driver",
																						"type" => "debit",
																						"amount" => rental_price_disc + additional_insurance + gps + baby_seat
																					},
																					{
																						"who" => "owner",
																						"type" => "credit",
																						"amount" =>  rental_price_disc - ( commission_from_rental_price/2 + number_rental_days * 100 + commission_from_rental_price/2 - number_rental_days * 100 ) + gps + baby_seat
																					},
																					{
																						"who" => "insurance",
																						"type" =>  "credit",
																						"amount" =>  commission_from_rental_price/2
																					},
																					{
																						"who" =>  "assistance",
																						"type" =>  "credit",
																						"amount" => number_rental_days * 100
																					},
																					{
																						"who" =>  "drivy",
																						"type" => "credit",
																						"amount" => commission_from_rental_price/2 - number_rental_days * 100 + additional_insurance
																					}
																				]})
	end
end

output_json 5, final_rentals_after_commission