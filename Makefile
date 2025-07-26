all: build test install

build:
	find ./filecomp -type f -name "*.sh" -exec chmod +x {} \;
	rm -rf filecomp.deb
	dpkg-deb --root-owner-group --verbose --build filecomp

test:
	dpkg -c filecomp.deb

install:
	sudo dpkg -i filecomp.deb
