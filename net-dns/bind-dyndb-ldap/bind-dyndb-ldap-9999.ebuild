# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 toolchain-funcs eutils

DESCRIPTION="Bind DynDB LDAP backend (replacement for sdb-ldap and dlz)"
HOMEPAGE="https://pagure.io/bind-dyndb-ldap"
#EGIT_REPO_URI="https://pagure.io/bind-dyndb-ldap.git"
#EGIT_REPO_URI="https://pagure.io/forks/benroberts/bind-dyndb-ldap.git"
#EGIT_BRANCH="bind9_12"
#EGIT_REPO_URI="https://github.com/freeipa/bind-dyndb-ldap"
#EGIT_REPO_URI="https://github.com/mingzym/bind-dyndb-ldap"
#EGIT_REPO_URI="https://github.com/dmolik/bind-dyndb-ldap.git"
EGIT_REPO_URI="https://github.com/kvaster/bind-dyndb-ldap.git"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	>=net-dns/bind-9.11[dlz]
	dev-libs/cyrus-sasl:=
	virtual/krb5
"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf

	#epatch "${FILESDIR}"/null-dn.patch

	eapply_user
}
