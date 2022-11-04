require './helpers'

def s3_object(output_location)
  @s3_object ||= Aws::S3::Object.new(ENV.fetch('AWS_BUCKET'),
                                     output_location,
                                     client: Aws::S3::Client.new)
end


# Stream the output on the fly via an IO
setup_and_teardown do |input_location, output_location|
  s3_object(output_location).upload_stream(tempfile: true) do |stream|
    Zlib::GzipWriter.wrap(stream) do |compressed_eligible_entries|
      File.foreach(input_location) do |line|
        compressed_eligible_entries << line if eligible?(line)
      end
    end
  end
end
