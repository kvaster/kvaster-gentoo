# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 10 11 12 13 )
POSTGRES_USEDEP="server"

inherit autotools eutils postgres-multi versionator

SLOT="0"

DESCRIPTION="Scalable PostgreSQL for multi-tenant and real-time workloads"
HOMEPAGE="https://www.citusdata.com/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/citusdata/${PN}.git"
else
	SRC_URI="https://github.com/citusdata/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"
REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="
	${POSTGRES_DEP}
	net-misc/curl[adns]
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
	postgres-multi_src_prepare
}
src_configure() {
	postgres-multi_foreach econf
}

src_compile() {
	postgres-multi_foreach emake
}

src_install() {
	postgres-multi_foreach emake DESTDIR="${D}" install

	use static-libs || find "${ED}" -name '*.a' -delete
}
