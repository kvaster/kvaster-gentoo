# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

POSTGRES_COMPAT=( 9.{4..6} {10..13} )
POSTGRES_USEDEP="server,static-libs"

inherit postgres-multi

SLOT="0"

DESCRIPTION="Logical Replication extension for PostgreSQL"
HOMEPAGE="http://2ndquadrant.com/en/resources/pglogical/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/2ndQuadrant/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/2ndQuadrant/${PN}/archive/REL${PV//./_}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-REL${PV//./_}"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="
	${POSTGRES_DEP}
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	postgres-multi_src_prepare
}

src_compile() {
	postgres-multi_foreach emake
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install
}
