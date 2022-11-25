require 'json'
require 'date'

def read_file level_file_input
  File.read("./backend/level#{ level_file_input }/data/input.json")
end

def convert_hash_data level_file_input
	JSON.parse( read_file ( level_file_input )  )
end

def output_json level_file_input, hash
  File.open("./backend/level#{ level_file_input }/output.json", "wb") { |file| file.puts JSON.pretty_generate( hash ) }
end

def number_rental_days start_date, finish_date
	start_date  = Date.parse(start_date)
	finish_date = Date.parse(finish_date)
	if finish_date >= start_date then ( finish_date - start_date ).to_i + 1 else 	raise "L'une des dates de début et plus grande que la date de fin" end

end
