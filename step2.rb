require './helpers'


def upload(data, output_location)
  s3 = Aws::S3::Client.new
  s3.put_object(bucket: ENV['AWS_BUCKET'], key: output_location, body: data)
end

# Compress the output on the fly via an IO
setup_and_teardown do |input_location, output_location|
  StringIO.open do |io|
    Zlib::GzipWriter.wrap(io) do |compressed_eligible_entries|
      File.foreach(input_location) do |line|
        compressed_eligible_entries << line if eligible?(line)
      end
    end
    upload(io.string, output_location)
  end
end
