require './helpers'

def compress(data)
  ActiveSupport::Gzip.compress(data)
end

def upload(data, output_location)
  s3 = Aws::S3::Client.new
  s3.put_object(bucket: ENV['AWS_BUCKET'], key: output_location, body: data)
end

# Read the file
# Process the content
# Upload the result
setup_and_teardown do |input_location, output_location|
  eligible_entries = []
  File.read(input_location).split(/\n/).each do |line|
    eligible_entries << line if eligible?(line)
  end
  compressed_eligible_entries = compress(eligible_entries.join("\n"))
  upload(compressed_eligible_entries, output_location)
end
