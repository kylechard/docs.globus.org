PRODBUCKET=docs.globus.org
STAGEBUCKET=docs.staging.globuscs.info

GEM_COMMAND?=gem

BUILD_TOOLS_DIR=.build_tools
VENV=$(BUILD_TOOLS_DIR)/venv

ASCIIDOC_VERSION=8.6.9
ASCIIDOC_TARBALL=asciidoc-$(ASCIIDOC_VERSION).tar.gz
ASCIIDOC_TARBALL_PATH=$(BUILD_TOOLS_DIR)/asciidoc-$(ASCIIDOC_VERSION).tar.gz
ASCIIDOC_URL=https://downloads.sourceforge.net/project/asciidoc/asciidoc/$(ASCIIDOC_VERSION)/$(ASCIIDOC_TARBALL)
ASCIIDOC_BUILD_DIR=$(BUILD_TOOLS_DIR)/asciidoc-$(ASCIIDOC_VERSION)
ASCIIDOC_INSTALL_DIR=$(shell pwd)/$(BUILD_TOOLS_DIR)/install


.PHONY: staging production build help build-tools

help:
	@echo "These are our make targets and what they do."
	@echo "All unlisted targets are internal."
	@echo ""
	@echo "  help:        Show this helptext"
	@echo "  build:       Rebuild the site"
	@echo "  production:  [build] + Upload to production site"
	@echo "  staging:     [build] + Upload to staging site"
	@echo "  build-tools: [asciidoc] + [nanoc] + [pygments] + [awscli]"
	@echo "  asciidoc:    Install asciidoc from source + modify with custom backend"
	@echo "  nanoc:       Install asciidoc nanoc via gem + bundle"
	@echo "  pygments:    Install pygments (in venv)"
	@echo "  awscli:      Install awscli (in venv)"
	@echo "  clean:       Remove currently installed versions of tools for [build]"
	@echo "                 Use sparingly -- usually the cleanup inherent in [build] is enough"

build: content build-tools
	./scripts/build.sh

staging: build
	./scripts/deploy.sh "$(STAGEBUCKET)"

production: build
	./scripts/deploy.sh "$(PRODBUCKET)"

clean:
	@rm -rf $(BUILD_TOOLS_DIR)



# build tool installation
# install the components necessary for doc building
build-tools: asciidoc nanoc pygments


asciidoc-setup: asciidoc/backends/bootstrap/bootstrap.conf asciidoc/backends/bootstrap/asciidoc.js
	./scripts/install_asciidoc_backend.sh "$(ASCIIDOC_INSTALL_DIR)"

$(ASCIIDOC_TARBALL_PATH):
	wget -nc -P $(BUILD_TOOLS_DIR) $(ASCIIDOC_URL)
	tar -C $(BUILD_TOOLS_DIR) -xzf $(ASCIIDOC_TARBALL_PATH)
	cd $(ASCIIDOC_BUILD_DIR) && autoconf
	cd $(ASCIIDOC_BUILD_DIR) && ./configure --prefix=$(ASCIIDOC_INSTALL_DIR)
	$(MAKE) -C $(ASCIIDOC_BUILD_DIR)
	$(MAKE) -C $(ASCIIDOC_BUILD_DIR) install
	$(MAKE) asciidoc-setup

asciidoc: $(ASCIIDOC_TARBALL_PATH)


# ensure that nanoc is a no-op if installed; but don't insist on rbenv, rvm, or
# other specific install procedure
ifeq ($(shell if which nanoc; then echo nanoc; fi),)
nanoc:
	$(GEM_COMMAND) install bundler --no-ri --no-rdoc
	bundle install
else
nanoc: ;
endif

$(VENV):
	virtualenv $(VENV)
	$(VENV)/bin/pip install -U pip setuptools

pygments: $(VENV)/bin/pygmentize
$(VENV)/bin/pygmentize: $(VENV)
	$(VENV)/bin/pip install -U pygments
awscli: $(VENV)/bin/aws
$(VENV)/bin/aws:
	$(VENV)/bin/pip install -U awscli
