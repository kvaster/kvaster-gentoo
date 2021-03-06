# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs eutils

DESCRIPTION="Bind DynDB LDAP backend (replacement for sdb-ldap and dlz)"
HOMEPAGE="https://pagure.io/bind-dyndb-ldap"

KEYWORDS=""

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/kvaster/bind-dyndb-ldap.git"
	inherit git-r3
else
    SRC_URI="https://github.com/kvaster/bind-dyndb-ldap/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	>=net-dns/bind-9.14.8[dlz]
	dev-libs/cyrus-sasl:=
	virtual/krb5
"

RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}
