require 'json'
require 'date'

class SharedLevels

	def initialize level_file_input
		@data_hash = JSON.parse( self.read_file( level_file_input )  )
		@final_rentals = { "rentals" => Array.new }
	end


    ## Level 1

	def level1
		@data_hash["cars"].each do |car|
			@data_hash["rentals"].each do |rental|

				if( car['id'] == rental['car_id'] )

					number_rental_days = self.number_rental_days( rental['start_date'], rental['end_date'] )

					rental_price = rental_price( car, number_rental_days, rental['distance'])

					@final_rentals["rentals"].push({ "id" => rental['id'],
																					"price" => rental_price
																				})
				end
			end
		end

		self.output_json 1, @final_rentals

	end


    ## Level 2

    def level2
        @data_hash["cars"].each do |car|
            @data_hash["rentals"].each do |rental|
                if( car['id'] == rental['car_id'] )
                    number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
                    rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
                    @final_rentals["rentals"].push({ "id" => rental['id'],
                                                                    "price" => rental_price_disc
                                                                })
                end
            end
        end

        output_json 2, @final_rentals
    end

    def rental_price_after_discount car, number_rental_days, distance
        if number_rental_days > 10
            price_after_discount =  (number_rental_days - 10) * car['price_per_day']/2 +
                                                                6*(car['price_per_day'] - (car['price_per_day']*30)/100) +
                                                                    3*(car['price_per_day'] - (car['price_per_day']*10)/100) + 2000

        elsif number_rental_days <=10 && number_rental_days > 4
            price_after_discount =  (number_rental_days - 4) * (car['price_per_day'] - (car['price_per_day']*30)/100) +
                                                                3 * (car['price_per_day'] - (car['price_per_day']*10)/100) + 2000

        elsif number_rental_days <= 4 && number_rental_days > 1
            price_after_discount =  (number_rental_days-1)*(car['price_per_day'] - (car['price_per_day']*10)/100) + 2000
        else
            price_after_discount = number_rental_days * car['price_per_day']
        end
        if number_rental_days < 0
            raise "BOOM: la diff entre les deux dates est négatif"
        end

        price_after_discount + car['price_per_km'] * distance
    end


    ## Level 3
    def level3
        @data_hash["cars"].each do |car|
            @data_hash["rentals"].each do |rental|
                if( car['id'] == rental['car_id'] )
                    number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
                    rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
                    commission_from_rental_price = ( rental_price_disc * 30)/100
                    @final_rentals[ "rentals" ].push({
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

        output_json 3, @final_rentals
    end



    ## lEVEL 4
    def level4
        @data_hash["cars"].each do |car|
            @data_hash["rentals"].each do |rental|
                if( car['id'] == rental['car_id'] )
                    number_rental_days = number_rental_days( rental['start_date'], rental['end_date'] )
                    rental_price_disc = rental_price_after_discount( car, number_rental_days, rental['distance'])
                    commission_from_rental_price = ( rental_price_disc * 30)/100
                    @final_rentals[ "rentals" ].push({
                                                            "id" => rental['id'],
                                                            "actions" => [{
                                                            "who" => "driver",
                                                            "type" => "debit",
                                                            "amount" => rental_price_disc
                                                        },
                                                        {
                                                            "who" => "owner",
                                                            "type" => "credit",
                                                            "amount" =>  rental_price_disc - ( commission_from_rental_price/2 + number_rental_days * 100 + commission_from_rental_price/2 - number_rental_days * 100 )
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
                                                            "amount" => commission_from_rental_price/2 - number_rental_days * 100
                                                        }
                                                        ]})
        end
            end
                end

        output_json 4, @final_rentals
    end

    ## Level5
    def level_5
        @data_hash["cars"].each do |car|

            @data_hash["rentals"].each do |rental|
                options = []
                gps =  0
                baby_seat = 0
                additional_insurance = 0
                @data_hash['options'].each do |opt|
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
                @final_rentals[ "rentals" ].push({
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

        output_json 5, @final_rentals
    end


    ## Shared functions

	def read_file level_file_input
		File.read("./backend/level#{ level_file_input }/data/input.json")
	end

	def output_json level_file_input, hash
		File.open("./backend/level#{ level_file_input }/output.json", "wb") { |file| file.puts JSON.pretty_generate( hash ) }
	end

	def rental_price car, number_rental_days, distance
			car['price_per_day'] * number_rental_days + car['price_per_km'] * distance
	end

	def number_rental_days start_date, finish_date
		start_date  = Date.parse(start_date)
		finish_date = Date.parse(finish_date)
		if finish_date >= start_date then ( finish_date - start_date ).to_i + 1 else raise "L'une des dates de début et plus grande que la date de fin" end

	end


end