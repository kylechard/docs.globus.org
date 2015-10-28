#!/bin/bash
set -e

### Command line opts ###

# Environment: options are {stg,staging,prod,production}. Defaults to staging
# get value and convert aliases to canonical names
env="$1"
if [[ -z "$env" || "$env" == "stg" ]];
then
    env="staging"
elif [ "$env" == "prod" ];
then
    env="production"
fi
# check for bad vals and exit if they are bad
if [[ "$env" != "staging" && "$env" != "production" ]];
then
    echo "Bad environment value: $env" >&2
    exit 1
fi

## check env to set destination bucket
if [ "$env" == "staging" ]
then
    bucket="docs.staging.globuscs.info"
else
    bucket="docs.globus.org"
fi


### Run deployment ###
echo "Deploying to $env"

# Reinstall asciidoc bootstrap backend
./install_asciidoc_backend.sh



# Build latest
echo "Compiling site with nanoc"
rm -rf output
nanoc

# copy output/ to S3
echo -e "\n\n--- Sync to S3 ---\n"
# do a non-delete sync to upload everything to the bucket
aws s3 sync output/ "s3://$bucket/"
# now do a delete sync to remove files absent from the output/ dir
# done as a separate second step to ensure good order of operations
aws s3 sync --delete output/ "s3://$bucket/"

# Done
echo -e "\n\n--- Success ---"
