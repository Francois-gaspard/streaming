require './helpers'

def s3_object(file_name)
  @s3_object ||= Aws::S3::Object.new(ENV.fetch('AWS_BUCKET'),
                                     "log/#{file_name}",
                                     client: Aws::S3::Client.new)
end

def s3_client
  Aws::S3::Client.new
end

poc_setup_and_teardown do |file_names|
  s3_object('output.zip').upload_stream do |upload_stream|
    ZipTricks::Streamer.open(upload_stream) do |compression_stream|
      file_names.each do |file_name|
        compression_stream.write_deflated_file(file_name) do |sink|
          s3_client.get_object(bucket: ENV.fetch('AWS_BUCKET'), key: "log/#{file_name}") do |chunk|
            sink << chunk
          end
        end
      end
    end
  end
end

# Errors: The specified key does not exist. (Aws::S3::Errors::NoSuchKey)
