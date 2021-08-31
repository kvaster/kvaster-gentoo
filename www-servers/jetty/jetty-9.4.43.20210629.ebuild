# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from bangert overlay

EAPI=5

inherit eutils user eapi7-ver

MAGIC=$(ver_cut 4-)
VER=$(ver_cut 1-3)

DESCRIPTION="Jetty is an full-featured web and applicaction server implemented entirely in Java."
HOMEPAGE="http://webtide.com"
SRC_URI="https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${VER}.v${MAGIC}/jetty-distribution-${VER}.v${MAGIC}.tar.gz"
LICENSE="Apache-2.0"
SLOT="6"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=virtual/jdk-1.8
	app-arch/unzip
	dev-java/java-config"
RDEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}"/jetty-distribution-${VER}.v${MAGIC}

JETTY_HOME="/opt/jetty"

pkg_setup() {
	enewgroup jetty
	enewuser jetty -1 /bin/bash ${JETTY_HOME} jetty
}

src_compile() {
	epatch "${FILESDIR}"/${VER}/daemon.patch

	# create features file
	mkdir gentoo
	cp "${FILESDIR}"/${VER}/features gentoo
}

src_install() {
	newinitd "${FILESDIR}"/${VER}/jetty.initd template.jetty

	dodir ${JETTY_HOME}

	insinto ${JETTY_HOME}
	doins start.jar
	doins -r resources
	doins -r lib
	doins -r modules
	doins -r etc
	doins -r gentoo
	doins -r "${FILESDIR}"/${VER}/gentoo
	doins -r "${FILESDIR}"/${VER}/etc

	fperms 0755 ${JETTY_HOME}/gentoo/jetty-instance-manager.bash

	exeinto ${JETTY_HOME}/bin
	doexe bin/jetty.sh
}

pkg_postinst() {
    elog "New ebuilds of Jetty support running multiple instances."

    elog "To manage Jetty instances, run:"
    elog "  ${EPREFIX}/opt/jetty/gentoo/jetty-instance-manager.bash --help"
}

