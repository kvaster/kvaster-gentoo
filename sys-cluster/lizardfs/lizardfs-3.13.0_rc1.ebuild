# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

EAPI=6

inherit eutils git-r3 autotools cmake-utils user

DESCRIPTION="LizardFS is an Open Source Distributed File System licenced under GPLv3."
HOMEPAGE="http://lizardfs.org"
SRC_URI=""

EGIT_REPO_URI="https://github.com/lizardfs/lizardfs.git"
EGIT_OVERRIDE_COMMIT_LIZARDFS_LIZARDFS="v3.13.0-rc1"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="cgi +fuse fuse3 static-libs -devel"

RDEPEND="
	cgi? ( dev-lang/python )
	!sys-cluster/moosefs
	dev-libs/judy
	fuse? ( =sys-fs/fuse-2* )
	fuse3? ( >=sys-fs/fuse-3.2 )
	dev-libs/isa-l
	>=sys-devel/gcc-6.3.0
	=dev-libs/spdlog-0.14.0"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply ${FILESDIR}/libraries_cmake.patch
	eapply ${FILESDIR}/iostat_header.patch
	default
}

pkg_setup() {
	enewgroup mfs
	enewuser mfs -1 -1 -1 mfs
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DENABLE_TESTS=NO
		-DENABLE_DOCS=NO
		-DCMAKE_INSTALL_PREFIX=/
		-DENABLE_DEBIAN_PATHS=YES
	)

if use devel; then
  mycmakeargs+=( -DENABLE_CLIENT_LIB=YES )
fi
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}/mfs.initd_${PV}" mfs
	newconfd "${FILESDIR}/mfs.confd" mfs

	if use cgi; then
		newinitd "${FILESDIR}/mfscgiserver.initd" mfscgiserver
		newconfd "${FILESDIR}/mfscgiserver.confd" mfscgiserver
	fi

	dodir /etc/pam.d
	insinto /etc/pam.d
	newins ${FILESDIR}/lizardfs.pam lizardfs

	dodir /etc/security/limits.d/
	insinto /etc/security/limits.d/
	newins ${FILESDIR}/lizardfs.lim lizardfs

	diropts -m0750 -o mfs -g mfs
	dodir "/var/lib/mfs"

	chown -R mfs:mfs "${D}var/lib/mfs" || die
	chmod 750 "${D}var/lib/mfs" || die
}
