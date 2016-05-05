# docs.globus.org

This is the source repo for the docs.globus.org site.
This repo supplies nanoc compiled HTML and assets for the production and
staging versions of the docs site for developer, admin, and user documentation.

The `Makefile` can be used to push out a production or staging site version.
More on the supported `make` targets below.

To get setup to use this repo, check out the
[Developer Setup Guide](/repo_metadoc/SETUP.md)


## Deploying Site Versions

Once you are setup, you can run `make` commands to roll out a site version.

Note that you can push any branch to production or staging.

### Staging

A staging deployment consists of

```sh
make staging
```

### Production

For production, the process is nearly identical

```sh
make production
```

### In-Place Build (No Deploy)

If you want to inspect the results of a build without actually pushing the
result to Staging or Production, just run

```sh
make build
```

### Updating Transfer API docs

First copy the latest adoc files from the designated koa branch (this
will vary), for example using rsync:

```sh
KOA_MANUAL=/koa/doc/manual/

cd "$KOA_MANUAL"
git fetch
git checkout -t origin/ballen/doc123
cd -

rsync -va "$KOA_MANUAL" content/api/transfer/ \
    --exclude 'private_*' --exclude Makefile
```

Then run the translation script:

```sh
scripts/translate_transfer_api_adoc.sh content/api/transfer
```

Check the git diff, and make sure the menu weights have not changed
(unless intended) and that nothing else unexpected has changed. Then
procede with build/deploy.
