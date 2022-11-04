require './helpers'

def compress(data)
  ActiveSupport::Gzip.compress(data)
end

def upload(data, output_location)
  s3 = Aws::S3::Client.new
  s3.put_object(bucket: ENV['AWS_BUCKET'], key: output_location, body: data)
end

# Intermediate step: Use an IO rather than an array to store eligible lines
setup_and_teardown do |input_location, output_location|
  StringIO.open do |io|
    File.foreach(input_location) do |line|
      io << line if eligible?(line)
    end
    compressed_eligible_entries = compress(io.string)
    upload(compressed_eligible_entries, output_location)
  end
end
