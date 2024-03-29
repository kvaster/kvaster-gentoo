# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Optimize the size of .PNG files losslessly"
HOMEPAGE="http://www.jonof.id.au/kenutils"
SRC_URI="http://static.jonof.id.au/dl/kenutils/${P}-linux.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND=${RDEPEND}

S="${WORKDIR}/${P}-linux"

src_install() {
	exeinto /opt/bin
	doexe amd64/${PN}

	dodoc readme.txt
}
