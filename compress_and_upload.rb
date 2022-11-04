require './helpers'

def compress(data)
  ActiveSupport::Gzip.compress(data)
end

def upload(data, output_location)
  s3 = Aws::S3::Client.new
  s3.put_object(bucket: ENV['AWS_BUCKET'], key: output_location, body: data) # /log/eligible_entries.log.gz'
end

# Read the file
# Process the content
# Upload the result
setup_and_teardown do |input_location, output_location|

end
