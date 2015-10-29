#!/bin/bash
set -e

# the first (and only) argument is the name of the destination S3 bucket
bucket="$1"

# go to the repo root
cd "$(dirname "$0")/.."

# copy output/ to S3
echo -e "\n\n--- Sync to S3 ---\n"
# do a non-delete sync to upload everything to the bucket
aws s3 sync output/ "s3://$bucket/"
# now do a delete sync to remove files absent from the output/ dir
# done as a separate second step to ensure good order of operations
aws s3 sync --delete output/ "s3://$bucket/"

# Done
echo -e "\n\n--- Success ---"
