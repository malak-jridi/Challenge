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