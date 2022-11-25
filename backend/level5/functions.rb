def number_rental_days start_date, finish_date
	start_date  = Date.parse(start_date)
	finish_date = Date.parse(finish_date)
	if finish_date >= start_date then ( finish_date - start_date ).to_i + 1 end
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

	price_after_discount + car['price_per_km'] * distance
end