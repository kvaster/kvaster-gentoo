# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Free Software Media System web panel"
HOMEPAGE="https://github.com/jellyfin/jellyfin-web"

if [[ ${PV} != 9999* ]] ; then
    SRC_URI="https://github.com/jellyfin/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm64"
    S="${WORKDIR}/${PN}-${PV/_/-}"
else
    inherit git-r3
    EGIT_REPO_URI="https://github.com/jellyfin/${PN}"
    EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
	S="${WORKDIR}/${PN}-${PV/_/-}/src"
fi

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
