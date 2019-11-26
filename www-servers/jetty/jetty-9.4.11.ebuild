# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from bangert overlay
inherit eutils user

MAGIC="20180605"

DESCRIPTION="Jetty is an full-featured web and applicaction server implemented entirely in Java."
HOMEPAGE="http://webtide.com"
SRC_URI="https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${PV}.v${MAGIC}/jetty-distribution-${PV}.v${MAGIC}.tar.gz"
LICENSE="Apache-2.0"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.8
	app-arch/unzip
	dev-java/java-config"
RDEPEND=">=virtual/jdk-1.8
	dev-java/jna"

S="${WORKDIR}"/jetty-distribution-${PV}.v${MAGIC}

JETTY_HOME="/opt/jetty"

pkg_setup() {
	enewgroup jetty
	enewuser jetty -1 /bin/bash ${JETTY_HOME} jetty
}

src_compile() {
	epatch "${FILESDIR}"/${PVR}/daemon.patch
	
	# create features file
	mkdir gentoo
	cp "${FILESDIR}"/${PVR}/features gentoo
}

src_install() {
	newinitd "${FILESDIR}"/${PVR}/jetty.initd template.jetty

	dodir ${JETTY_HOME}

	insinto ${JETTY_HOME}
	doins start.jar
	doins -r lib
	doins -r resources
	doins -r modules
	doins -r etc
	doins -r gentoo
	doins -r "${FILESDIR}"/${PVR}/gentoo
	doins -r "${FILESDIR}"/${PVR}/etc
	doins -r "${FILESDIR}"/${PVR}/lib
	doins -r "${FILESDIR}"/${PVR}/modules
	
	fperms 0755 ${JETTY_HOME}/gentoo/jetty-instance-manager.bash

	dosym /usr/share/jna/lib/jna.jar ${JETTY_HOME}/lib/kvaster-utils/jna.jar

	exeinto ${JETTY_HOME}/bin
	doexe bin/jetty.sh
}

pkg_postinst() {
    elog "New ebuilds of Jetty support running multiple instances."

    elog "To manage Jetty instances, run:"
    elog "  ${EPREFIX}/opt/jetty/gentoo/jetty-instance-manager.bash --help"
}

