# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAGIC=$(ver_cut 4-)
VER=$(ver_cut 1-3)

DESCRIPTION="Jetty - web and applicaction server for Java."
HOMEPAGE="http://webtide.com"
SRC_URI="https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/${VER}.v${MAGIC}/jetty-distribution-${VER}.v${MAGIC}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
>=virtual/jdk-1.8
acct-user/jetty
"

DEPEND="
${RDEPEND}
app-arch/unzip
dev-java/java-config
"

S="${WORKDIR}"/jetty-distribution-${VER}.v${MAGIC}

JETTY_HOME="/opt/jetty"

PATCHES=(
	"${FILESDIR}/${VER}/daemon.patch"
)

src_compile() {
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
