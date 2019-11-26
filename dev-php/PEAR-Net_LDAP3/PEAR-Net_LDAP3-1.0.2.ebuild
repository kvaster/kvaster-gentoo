EAPI="5"

inherit git-2 eutils

EGIT_REPO_URI="https://git.kolab.org/diffusion/PNL/php-net_ldap.git"
[[ ${PV} == "9999" ]] || EGIT_TAG="pear-Net-LDAP3-${V}"
#EGIT_COMMIT="${PV}"

KEYWORDS="alpha amd64 hppa ppc sparc x86"

DESCRIPTION="OO interface for searching and manipulating LDAP-entries"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/php[ldap]"

PHP_PEAR_DIR="/usr/share/php"

#src_prepare() {
#
#	# Apply patches
#    cd "${S}"
#    for p in $(find ${FILESDIR} -iname "${P}-*.patch") ; do
#		epatch "${p}"
#	done
#}

src_install() {
        insinto "${PHP_PEAR_DIR}/"
        doins -r lib/*
}
