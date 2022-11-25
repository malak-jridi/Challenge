def rental_price car, number_rental_days, distance
    car['price_per_day'] * number_rental_days + car['price_per_km'] * distance
end