build:
	echo "Build FileComp v0.1.0"
	find ./filecomp -type f -name "*.sh" -exec chmod +x {} \;
	rm -rf filecomp.deb
	dpkg-deb --root-owner-group --verbose --build filecomp
