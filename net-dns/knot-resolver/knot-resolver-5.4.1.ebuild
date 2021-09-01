# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A caching full DNS resolver implementation written in C and LuaJIT"
HOMEPAGE="https://www.knot-resolver.cz"
SRC_URI="https://secure.nic.cz/files/${PN}/${P}.tar.xz"
RESTRICT="mirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dnstap systemd +pie"

RDEPEND="
	>=net-dns/knot-3.0.0
	>=dev-libs/libuv-1.7.0
	dev-lang/luajit:2
	dev-lua/luasocket
	dev-lua/luasec
	net-libs/libnsl
	net-libs/gnutls
	dev-db/lmdb
	dnstap? (
		>=dev-libs/protobuf-3.0
		dev-libs/protobuf-c
		dev-libs/fstrm
	)
	acct-user/knot-resolver
"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.46.0
	virtual/pkgconfig
	dev-util/ninja
"

src_configure() {
	local emesonargs=(
			-Dsystemd_files=$(usex systemd enabled disabled)
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	fowners -R knot-resolver:knot-resolver /etc/knot-resolver
	fperms -R 0750 /etc/knot-resolver

	diropts -o knot-resolver -g knot-resolver -m 0750
	keepdir /var/log/${PN}
	keepdir /var/lib/${PN}

	newinitd "${FILESDIR}"/kresd.initd kresd
	newconfd "${FILESDIR}"/kresd.confd kresd
}
