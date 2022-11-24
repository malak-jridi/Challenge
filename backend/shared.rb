require 'json'

def read_file
  File.read( './backend/level1/data/input.json' )
end

def convert_hash_data
	JSON.parse( read_file )
end

def json_to_hash file_path
    File.read( file_path )
end