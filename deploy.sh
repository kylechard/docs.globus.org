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


### Config ###
# Current branch
branch="$(git rev-parse --abbrev-ref HEAD)"


### Setup for staging deployment
if [ "$env" == "staging" ]
then
    domain_name="docs.staging.globuscs.info"
    repo_dir='docs.globus.org-staging'
    repo_url='git@github.com:globusonline/docs.globus.org-staging.git'
fi


### Setup for prod deployment
if [ "$env" == "production" ]
then
    # ensure that current branch is prod
    if [ "$branch" != "prod" ]
    then
        echo "Sorry! You must be on 'prod' branch to deploy to production."
        exit 1
    fi

    domain_name="github-pages.docs.globus.org"
    repo_dir='docs.globus.org'
    repo_url='git@github.com:globusonline/docs.globus.org.git'
fi


### Run deployment ###
echo "Deploying to $env"

# Reinstall asciidoc bootstrap backend
./install_asciidoc_backend.sh


# Remove repo if exists
if [ -d "$repo_dir" ]; then
  rm -rf "$repo_dir"
fi
# Clone repo and clean
git clone "$repo_url" "$repo_dir"
cd "$repo_dir"
git checkout gh-pages
git add -u
git rm -r ./*
rm -rf ./*




# Build latest
echo "Compiling nanoc"
cd ../
rm -rf output
nanoc


# Build the correct CNAME file for the env
# Commit and push the changes to the sites dir
cd "$repo_dir"

echo "Generating CNAME"
echo "$domain_name" > CNAME


echo "Adding and committing changes"
cp -R ../output/* .
git add -A
git commit -v
git push origin gh-pages

# Remove repo directory
cd ..
rm -rf "$repo_dir"

# Done
echo "** Remember to commit your source files"
