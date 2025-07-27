# -------------------------------
# CONFIG
# -------------------------------

NAME        := filecomp
VERSION     := $(shell grep '^Version:' src/DEBIAN/control | awk '{print $$2}')
ARCH        := all
PKGFILE     := $(NAME)_$(VERSION)_$(ARCH).deb
SRCDIR      := src
OUTDIR      := build
REPOPOOL    := ../../deb/pool/main/f/$(NAME)
DEBFILE     := $(OUTDIR)/$(PKGFILE)

# -------------------------------
# TARGETS
# -------------------------------

.PHONY: all clean build check install release

# Default-Target
all: build

## Clean directory
clean:
	@echo "[*] Remove previous builds ..."
	rm -rf $(OUTDIR)
	rm -f $(NAME).deb

## Build package
build:
	@echo "[*] Set execution rights for .sh files ..."
	find $(SRCDIR) -type f -name "*.sh" -exec chmod +x {} \;
	@echo "[*] Create package directory ..."
	mkdir -p $(OUTDIR)
	@echo "[*] Build Debian package: $(PKGFILE)"
	dpkg-deb --root-owner-group --build $(SRCDIR) $(DEBFILE)
	ln -sf $(DEBFILE) $(NAME).deb
	@echo "[✓] Package created under: $(DEBFILE)"

## Test package
check:
	@echo "[*] Check package files ..."
	dpkg -c $(DEBFILE)
	@echo "[*] Check package installation locally ..."
	sudo dpkg -i $(DEBFILE)

## Local installation (alias for check)
install: check

## Release to repository
release: build
	@echo "[*] Copy package to repository directory ..."
	mkdir -p $(REPOPOOL)
	cp $(DEBFILE) $(REPOPOOL)/
	@echo "[*] Update repository metadata ..."
	cd $(dir $(REPOPOOL))/../../../ && ./build-repo.sh
	@echo "[✓] Release completed: Version $(VERSION) published."
