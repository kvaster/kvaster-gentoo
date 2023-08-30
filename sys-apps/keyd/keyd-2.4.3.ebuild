EAPI=8

inherit autotools

DESCRIPTION="Key remapping daemon which remaps keys using kernel level input primitives"
HOMEPAGE="https://github.com/rvaiya/keyd"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rvaiya/${PN}.git"
else
	SRC_URI="https://github.com/rvaiya/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND="acct-group/keyd"
RDEPEND=""

src_install() {
	dobin "bin/keyd"
	dobin "bin/keyd-application-mapper"

	newconfd "${FILESDIR}"/keyd.confd ${PN}
	newinitd "${FILESDIR}"/keyd.initd ${PN}

	insinto /etc/keyd
	doins "${FILESDIR}"/default.conf

	# TODO: fix doc dir
	insinto /usr/share/doc/keyd
	doins docs/*.md
	# TODO: fix doc dir
	insinto /usr/share/doc/keyd/examples
	doins examples/*
	insinto /usr/share/keyd/layouts
	doins layouts/*
	insinto /usr/share/man/man1
	doins data/*.1.gz
	insinot /usr/share/keyd
	doins data/keyd.compose
}
