# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="The Free Software Media System web panel"
HOMEPAGE="https://github.com/jellyfin/jellyfin-web"

if [[ ${PV} != 9999* ]] ; then
    SRC_URI="https://github.com/jellyfin/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm ~arm64"
    S="${WORKDIR}/${PN}-${PV/_/-}"
else
    inherit git-r3
    EGIT_REPO_URI="https://github.com/jellyfin/${PN}"
    EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror network-sandbox"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/yarn"

src_compile() {
	yarn install || die
}

src_install() {
	insinto /usr/share/jellyfin/web
	doins -r dist/.
}
