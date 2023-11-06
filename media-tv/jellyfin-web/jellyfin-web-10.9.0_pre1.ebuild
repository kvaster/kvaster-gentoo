# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Free Software Media System web panel"
HOMEPAGE="https://github.com/jellyfin/jellyfin-web"

EGIT_COMMIT="b0d7f93ae81c128b63278b176b18994b8aa2823d"

inherit git-r3
EGIT_REPO_URI="https://github.com/jellyfin/${PN}"
EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
S="${WORKDIR}/${PN}-${PV/_/-}/src"

LICENSE="GPL-2+"
SLOT="0"

RESTRICT="mirror network-sandbox"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="net-libs/nodejs[npm]"

src_compile() {
	npm ci --no-audit || die
	npm run build:production || die
}

src_install() {
	insinto /usr/share/jellyfin/web
	doins -r dist/.
}
