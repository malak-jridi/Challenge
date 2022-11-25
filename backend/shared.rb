require 'json'

def read_file level_file_input
  File.read("./backend/level#{ level_file_input }/data/input.json")
end

def convert_hash_data level_file_input
	JSON.parse( read_file ( level_file_input )  )
end