PRODBUCKET="docs.globus.org"
STAGEBUCKET="docs.staging.globuscs.info"

.PHONY: staging production

asciidoc-setup: asciidoc/backends/bootstrap/bootstrap.conf asciidoc/backends/bootstrap/asciidoc.js
	./scripts/install_asciidoc_backend.sh

build: content asciidoc-setup
	./scripts/build.sh

staging: build
	./scripts/deploy.sh "$(STAGEBUCKET)"

production: build
	./scripts/deploy.sh "$(PRODBUCKET)"
