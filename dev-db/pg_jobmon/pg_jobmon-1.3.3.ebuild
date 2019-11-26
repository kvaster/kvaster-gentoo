# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 10 11 )
POSTGRES_USEDEP="server"

inherit eutils postgres-multi versionator

SLOT="0"

DESCRIPTION="PostgreSQL extension which provides persistent logging within transactions and functions."
HOMEPAGE="https://github.com/omniti-labs/pg_jobmon"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/omniti-labs/${PN}.git"
else
	SRC_URI="https://github.com/omniti-labs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="
	${POSTGRES_DEP}
"
RDEPEND="${DEPEND}"
