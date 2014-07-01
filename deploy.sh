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

### Current branch
branch=`git rev-parse --abbrev-ref HEAD`

# if [ $branch != 'master' -o $branch != 'prod' ]
# then
#  echo "Oops! You must be on either master or prod branch to run $0"
#  exit 1
# fi

### Setup for staging deployment
if [ $env == 'stg' ]
then
  # Make sure on master branch
  if [ $branch != 'master' ]
  then
    echo "Sorry! You must be on master branch to deploy to staging."
    exit 1
  fi

  sitesDir='dev.globus.org-staging'
fi


exit 0

### Config ###
# Jekyll destination directory, usually _sites
sitesDir='dev.globus.org'

# Use custom domain?
customDomain=true

# The url of your production site
# prodUrl="dev.globus.org"
prodUrl="dev.globuscs.info"

# The url of your dev/staging site
# devUrl="staging.dev.globus.org"
devUrl="dev.staging.globuscs.info"

# The name of the development git remote
devRemote="staging"

# The name of the prod git remote
prodRemote="prod"

# The name of the branch used by GH pages (probably gh-pages)
ghPagesBranch="gh-pages"



# if  [[ -z "$branch" ]]; then
#   branch=$ghbranch
# fi



./install_asciidoc_backend.sh

echo "Deploying to $env"

# Clean up the sites dir, pull any outstanding changes
echo "Updating sites with remote changes in $sitesDir"
cd ./$sitesDir
echo ${PWD}
git checkout gh-pages
git pull origin gh-pages
git rm -r .
git commit -a -m 'deleted last commit'


# Build latest
cd ../
echo "Compiling nanoc"
nanoc
cp -R output/* $sitesDir


# Build the correct CNAME file for the env
cd ./$sitesDir

if [ $customDomain == true ]
then
  echo "Generating CNAME"
  if [ $env == 'stg' ]; then
    echo $devUrl > CNAME
  else
    echo $prodUrl > CNAME
  fi
fi


# Commit and push the changes to the sites dir
echo "Adding and committing destination files"
# if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
# then
  git add ./
  git commit -a -m "$message"
# else
  # echo "Nothing to commit"
# fi
git push origin gh-pages

cd ..
echo "** Remember to commit your source files"

# Commit and push the changes to the source dir
# echo "Adding and committing source files"
# cd ..
# if [[ $(git diff --shortstat 2> /dev/null | tail -n1) != "" ]]
# then
#   git add ./
#   git commit -a -m "$message"
# else
#   echo "Nothing to commit"  
# fi
# git push origin $branch
