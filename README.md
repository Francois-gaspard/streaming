# Streaming

This is a proof of concept script for the use of IOs and data streaming in large data processing.

The premise is the following made-up scenario:

> Given a Rails log file, 
> When running the script, 
> eligible lines from that log file must be collected, gzipped and uploaded to S3

The eligibility of each line is fairly irrelevant here. In this case, each line has a 50% probability of being selected.
A more realistic (but more input-dependent) scenario could be: Eligible lines are lines that contain 'Error'. 

The repository contains 4 iterations of the script, from most basic to most advanced.
Each iteration goal is to demonstrate the performance and resource gains we can get from using IOs and data streaming.

## Requirements
Ruby Version 3.1.2 and above.

## Installation
Execute:
```
$ bundle install
```
You will need a S3 bucket and the following ENV variables set:
```
AWS_ACCESS_KEY_ID
AWS_BUCKET
AWS_REGION
AWS_SECRET_ACCESS_KEY
```
The ACCESS_KEYs can be generated from your AWS account:

- Click on your user name (top right) > Security Credentials
- Select "Create access key"
- Once created, both aws_access_key_id and aws_secret_access_key will be shown.

Finally, a ~18MB fake input log file is provided under `log/18.log`.
Feel free to experiment with smaller or larger files. Just change
the input location in `helpers#setup_and_teardown` to your own file.

## Running the scripts:
This is just ruby code, so:
```
ruby step0.rb
```
You may need to pass ENV variables as well, depending on how you set them.
