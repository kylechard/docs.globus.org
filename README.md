# docs.globus.org

This is the source repo for the docs.globus.org site.
This repo supplies nanoc compiled HTML and assets for the production and
staging versions of the docs site for developer, admin, and user documentation.

The `deploy.sh` script can be used to push out a production or staging site
version.
More on this script below.

To get setup to use this repo, check out the
[Developer Setup Guide](/repo_metadoc/SETUP.md)


## Deploying Site Versions

Once you are setup, you can run the deploy script to roll out a site version.

### Special Note for Virtualenv and RVM

If you are running a virtualenv or RVM for deploy script dependencies, you will
need to take an additional step in your shell before running the script.

Run

```sh
export PATH=$PATH
```

to expose the `PATH` variable -- modified by RVM and/or virtualenv -- to the
deploy script.

`export` in the shell ensures that scripts you invoke will get the variable
being exported as part of their environment.

This is necessary in order to ensure that the deploy script finds `nanoc` and
other tools.

### Staging

A staging deployment consists of

```sh
git checkout staging # if you aren't already on staging
./deploy.sh staging
```

Note that staging deployments don't strictly enforce that you are on the
staging branch -- you can technically deploy staging from any branch.

### Production

For production, the process is nearly identical

```sh
git checkout prod # if you aren't already on prod
./deploy.sh production
```
