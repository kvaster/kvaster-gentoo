# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils git-r3

DESCRIPTION="An open-source interface to Z-Wave networks."
HOMEPAGE="http://open-zwave.googlecode.com"
EGIT_REPO_URI="https://github.com/OpenZWave/open-zwave.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""
SLOT="0"

DEPEND="dev-libs/libxml2"
RDEPEND="${RDEPEND}"

src_compile() {
	epatch "${FILESDIR}"/makefile.patch || die
	emake -C cpp/build PREFIX=/usr default pkgconfig || die
}

src_install() {
	dodir /etc/openzwave
	dodir /usr/include/openzwave
	dodir /usr/lib

	insinto /etc/openzwave
	doins -r config/*

	exeinto /usr/lib
	dolib.so cpp/build/libopenzwave.so
	dolib.a cpp/build/libopenzwave.a
	dolib cpp/build/libopenzwave.so.*

	insinto /usr/include/openzwave
	doins cpp/src/*.h
	insinto /usr/include/openzwave/value_classes
	doins cpp/src/value_classes/*.h
	insinto /usr/include/openzwave/command_classes
	doins cpp/src/command_classes/*.h
	insinto /usr/include/openzwave/platform
	doins cpp/src/platform/*.h
	insinto /usr/include/openzwave/platform/unix
	doins cpp/src/platform/unix/*.h
	insinto /usr/include/openzwave/aes
	doins cpp/src/aes/*.h

	insinto /usr/lib/pkgconfig
	doins cpp/build/libopenzwave.pc
}
