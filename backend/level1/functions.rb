def number_rental_days start_date, finish_date
	start_date  = Date.parse(start_date)
	finish_date = Date.parse(finish_date)
	if finish_date >= start_date then ( finish_date - start_date ).to_i + 1 end
end

def rental_price car, number_rental_days, distance
    car['price_per_day'] * number_rental_days + car['price_per_km'] * distance
end