# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

POSTGRES_COMPAT=( 10 11 12 13 )
POSTGRES_USEDEP="server"

inherit eutils postgres-multi versionator

SLOT="0"

DESCRIPTION="Partition management extension for PostgreSQL"
HOMEPAGE="https://github.com/pgpartman/pg_partman"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pgpartman/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/pgpartman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE=""
REQUIRED_USE="${POSTGRES_REQ_USE}"

DEPEND="
	${POSTGRES_DEP}
"
RDEPEND="${DEPEND}"

