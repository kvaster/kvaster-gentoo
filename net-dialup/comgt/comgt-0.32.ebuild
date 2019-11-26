# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="UMTS/GPRS command-line tool"
HOMEPAGE="http://comgt.sourceforge.net/"
SRC_URI="mirror://sourceforge/comgt/comgt.${PV}.tgz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"

src_unpack() {
	unpack ${A}
	mv comgt.${PV} comgt-${PV}
	cd "${S}"
	epatch "${FILESDIR}"/change-install-destination.patch
}

src_compile() {
	emake || die "Error: emake failed !"
}

src_install() {
	mkdir -p "${D}"/usr/sbin
	mkdir -p "${D}"/usr/share/man/man1
	mkdir -p "${D}"/etc
	DESTDIR="${D}" make install || die "install failed !"
}
