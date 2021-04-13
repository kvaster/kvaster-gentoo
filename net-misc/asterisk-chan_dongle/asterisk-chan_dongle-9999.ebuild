# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=7

inherit eutils git-r3 autotools

DESCRIPTION="Asterisk Huawei 3G Dongle Channel Driver."
EGIT_REPO_URI="https://github.com/oleg-krv/asterisk-chan-dongle.git"
EGIT_BRANCH="asterisk13"
HOMEPAGE="https://github.com/oleg-krv/asterisk-chan-dongle"
KEYWORDS=""

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND=">=net-misc/asterisk-1.6.2.0"
DEPEND="${RDEPEND}"

AT_NOEAUTOMAKE=yes

src_prepare() {
	cd ${S}
	epatch "${FILESDIR}"/ussd-encoding.patch
	epatch "${FILESDIR}"/ussd-app.patch
	eaclocal
	eautoconf
	automake -a
}

src_install() {
	insinto /usr/$(get_libdir)/asterisk/modules
	doins "${PN/*-/}.so"
	insinto /etc/asterisk
	doins etc/dongle.conf
	newdoc README.txt README
	newdoc LICENSE.txt LICENSE
	newdoc etc/extensions.conf extensions.conf.chan_dongle
}
