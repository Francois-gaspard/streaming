require 'benchmark'
require 'active_support/gzip'
require 'zlib'
require 'aws-sdk-s3'
require 'zip_tricks'

def print_memory_usage
  memory_before = `ps -o rss= -p #{Process.pid}`.to_i
  yield
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i

  puts "Memory: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
end

def print_time_spent(&)
  time = Benchmark.realtime(&)

  puts "Time: #{time.round(2)}"
end

def setup_and_teardown(&)
  input_location = 'log/18.log' # Rails log location (input)
  output_location = 'log/eligible_entries.log.gz' # Where in the S3 bucket we will write the data
  print_memory_usage do
    # Measures memory before and after running the code
    print_time_spent do
      # Measures the time taken to run the code
      yield(input_location, output_location)
    end
  end
end

def poc_setup_and_teardown(&)
  file_names = %w[medium.log small.log] # Location of input file on S3
  print_memory_usage do
    # Measures memory before and after running the code
    print_time_spent do
      # Measures the time taken to run the code
      yield(file_names)
    end
  end
end

def eligible?(_line)
  rand > 0.5
end
