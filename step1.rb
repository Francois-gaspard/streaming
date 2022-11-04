require './helpers'

def compress(data)
  ActiveSupport::Gzip.compress(data)
end

def upload(data, output_location)
  s3 = Aws::S3::Client.new
  s3.put_object(bucket: ENV['AWS_BUCKET'], key: output_location, body: data)
end

# Take advantage of IO's foreach to read
# the input line-by-line and never store the input fully in memory
setup_and_teardown do |input_location, output_location|
  eligible_entries = []
  File.foreach(input_location) do |line|
    eligible_entries << line if eligible?(line)
  end
  compressed_eligible_entries = compress(eligible_entries.join)
  upload(compressed_eligible_entries, output_location)
end
