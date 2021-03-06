# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="The Free Software Media System web panel"
HOMEPAGE="https://github.com/jellyfin/jellyfin-web"

SRC_URI="https://github.com/jellyfin/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror network-sandbox"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="sys-apps/yarn"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_compile() {
	yarn install || die
}

src_install() {
	insinto /usr/share/jellyfin/web
	doins -r dist/.
}
