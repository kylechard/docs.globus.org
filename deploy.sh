#!/bin/bash
set -e

### Check proper usage
if [[ -z $1 ]]
then
  echo "Usage: $0 'commit message' [env]"
  exit 1
fi


### Command line opts ###
message=$1 #commit message
env=${2-stg} # Environment: options are 'stg' and 'prod'. Defaults to 'stg'


### Config ###
# Current branch
branch=`git rev-parse --abbrev-ref HEAD`

# Use custom domain?
customDomain=true

# The url of your production site
# prodUrl="dev.globus.org"
prodDomain="dev.globus.org"

# The url of your dev/staging site
# devUrl="staging.dev.globus.org"
devDomain="dev.staging.globuscs.info"


### Setup for staging deployment
if [ $env == 'stg' ]
then
  # Make sure on staging branch
  if [ $branch != 'staging' ]
  then
    echo "Sorry! You must be on 'staging' branch to deploy to staging."
    exit 1
  fi

  sitesDir='dev.globus.org-staging'
  repoUrl='git@github.com:globusonline/dev.globus.org-staging.git'
fi


### Setup for prod deployment
if [ $env == 'prod' ]
then
  # Make sure on staging branch
  if [ $branch != 'prod' ]
  then
    echo "Sorry! You must be on 'prod' branch to deploy to production."
    exit 1
  fi

  sitesDir='dev.globus.org'
  repoUrl='git@github.com:globusonline/dev.globus.org.git'
fi


### Run deployment ###
echo "Deploying to $env"

# Reinstall asciidoc bootstrap backend
./install_asciidoc_backend.sh


# Remove site directory if exists
if [ -d $sitesDir ]; then
  rm -rf $sitesDir
fi
# Clone repo and clean
git clone $repoUrl $sitesDir
cd $sitesDir
git checkout gh-pages
git add -u
git rm -r *




# Build latest
echo "Compiling nanoc"
cd ../
rm -rf output
nanoc


# Build the correct CNAME file for the env
# Commit and push the changes to the sites dir
cd $sitesDir

if [ $customDomain == true ]
then
  echo "Generating CNAME"
  if [ $env == 'stg' ]; then
    echo $devDomain > CNAME
  else
    echo $prodDomain > CNAME
  fi
fi

echo "Adding and committing changes"
cp -R ../output/* .
git add -A
git commit -a -m "$message"
git push origin gh-pages

# Remove site directory
cd ..
rm -rf $sitesDir

# Done
echo "** Remember to commit your source files"
