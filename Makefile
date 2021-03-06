# version
VERSION=0.5
BUILD=1

# sbin
TARGET=sbin/leech
MATCH_TEST_TARGET=sbin/leech-match-test
RFC822_TO_UNIX_TARGET=sbin/rfc822tounix

# recipes (also sbin)
RECIPE_DEFAULT=sbin/recipes/leech-default
RECIPE_TRANSMISSION=sbin/recipes/leech-transmission

# stuff
XSL=share/leech/leech.xsl
CONFIG_FILES=config/default config/foods config/downloads
BUILD_DIR=pkg_build

# packages
IPK_TARGET=leech_${VERSION}-${BUILD}_all.ipk
DEB_TARGET=leech_${VERSION}-${BUILD}_all.deb

default: executable ipk deb

executable:
	chmod +x "${TARGET}"
	chmod +x "${MATCH_TEST_TARGET}"
	chmod +x "${RFC822_TO_UNIX_TARGET}"
	chmod +x "${RECIPE_DEFAULT}"
	chmod +x "${RECIPE_TRANSMISSION}"

clean:
	rm -fr "${BUILD_DIR}"
	rm -f "${IPK_TARGET}"
	rm -f "${DEB_TARGET}"

deb:
	mkdir -p "${BUILD_DIR}"
	
	# control
	mkdir -p "${BUILD_DIR}/DEBIAN"
	cp build/deb/control build/deb/conffiles "${BUILD_DIR}/DEBIAN/"
	
	# data
	mkdir -p "${BUILD_DIR}/etc/leech"
	mkdir -p "${BUILD_DIR}/usr/sbin"
	mkdir -p "${BUILD_DIR}/usr/share/leech"
	
	cp ${CONFIG_FILES} "${BUILD_DIR}/etc/leech/"
	cp "${TARGET}" "${MATCH_TEST_TARGET}" "${RFC822_TO_UNIX_TARGET}" "${BUILD_DIR}/usr/sbin/"
	cp "${RECIPE_DEFAULT}" "${RECIPE_TRANSMISSION}" "${BUILD_DIR}/usr/sbin/"
	cp "${XSL}" "${BUILD_DIR}/usr/share/leech/"
	chmod +x "${BUILD_DIR}/usr/${TARGET}"
	chmod +x "${BUILD_DIR}/usr/${MATCH_TEST_TARGET}"
	chmod +x "${BUILD_DIR}/usr/${RFC822_TO_UNIX_TARGET}"
	chmod +x "${BUILD_DIR}/usr/sbin/$(shell basename ${RECIPE_DEFAULT})"
	chmod +x "${BUILD_DIR}/usr/sbin/$(shell basename ${RECIPE_TRANSMISSION})"
	
	# deb
	fakeroot dpkg -b "${BUILD_DIR}" "${DEB_TARGET}"
	
	# cleanup
	rm -fr "${BUILD_DIR}"

ipk:
	mkdir -p "${BUILD_DIR}"
	echo "2.0" > "${BUILD_DIR}/debian-binary"
	
	# control.tar.gz
	mkdir -p "${BUILD_DIR}/CONTROL"
	cp build/ipkg/control build/ipkg/conffiles "${BUILD_DIR}/CONTROL/"
	
	# data.tar.gz
	mkdir -p "${BUILD_DIR}/usr/sbin" "${BUILD_DIR}/usr/share/leech" "${BUILD_DIR}/etc/leech"
	cp ${CONFIG_FILES} "${BUILD_DIR}/etc/leech/"
	cp "${TARGET}" "${MATCH_TEST_TARGET}" "${RFC822_TO_UNIX_TARGET}" "${BUILD_DIR}/usr/sbin/"
	cp "${RECIPE_DEFAULT}" "${RECIPE_TRANSMISSION}" "${BUILD_DIR}/usr/sbin/"
	cp "${XSL}" "${BUILD_DIR}/usr/share/leech/"
	chmod +x "${BUILD_DIR}/usr/${TARGET}"
	chmod +x "${BUILD_DIR}/usr/${MATCH_TEST_TARGET}"
	chmod +x "${BUILD_DIR}/usr/${RFC822_TO_UNIX_TARGET}"
	chmod +x "${BUILD_DIR}/usr/sbin/$(shell basename ${RECIPE_DEFAULT})"
	chmod +x "${BUILD_DIR}/usr/sbin/$(shell basename ${RECIPE_TRANSMISSION})"
	
	# leech.ipk
	fakeroot build/ipkg-build "${BUILD_DIR}"
	
	# cleanup
	rm -fr "${BUILD_DIR}"
