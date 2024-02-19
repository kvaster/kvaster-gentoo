# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Maven Repository Manager"
HOMEPAGE="http://nexus.sonatype.org/"
LICENSE="GPL-3"
MY_PN="nexus"
MY_PV="$(ver_cut 1-3)-$(ver_cut 4)"
MY_P="${MY_PN}-${MY_PV}"
MY_MV="3"

SRC_URI="http://download.sonatype.com/${MY_PN}/${MY_MV}/${MY_P}-unix.tar.gz"
RESTRICT="mirror"
KEYWORDS="~x86 ~amd64"
SLOT="${MY_MV}"
IUSE=""
S="${WORKDIR}"
INSTALL_DIR="/opt/nexus-oss"

DEPEND="acct-user/nexus"
RDEPEND="
>=virtual/jdk-1.8
${DEPEND}"

src_unpack() {
	unpack ${A}
}

src_install() {
	insinto /var/lib/nexus
	doins -r sonatype-work/*
	fowners -R nexus:nexus /var/lib/nexus

	insinto /etc/nexus
	doins "${MY_P}"/bin/nexus.rc
	rm "${MY_P}"/bin/nexus.rc
	doins "${MY_P}"/bin/nexus.vmoptions
	rm "${MY_P}"/bin/nexus.vmoptions
	doins "${MY_P}"/etc/nexus-default.properties
	rm "${MY_P}"/etc/nexus-default.properties

	insinto ${INSTALL_DIR}
	doins -r "${MY_P}"/*
	doins -r "${MY_P}"/.??*
	dosym /etc/nexus/nexus.rc ${INSTALL_DIR}/bin/nexus.rc
	dosym /etc/nexus/nexus.vmoptions ${INSTALL_DIR}/bin/nexus.vmoptions
	dosym /etc/nexus/nexus-default.properties ${INSTALL_DIR}/etc/nexus-default.properties

	newinitd "${FILESDIR}/nexus.initd" nexus
	newconfd "${FILESDIR}/nexus.confd" nexus

	fowners -R nexus:nexus ${INSTALL_DIR}
	fperms 755 "${INSTALL_DIR}/bin/nexus"

	#echo "Change  NEXUS_HOME  to the absolute folder location in your  .bashrc  file, then save"
	echo NEXUS_HOME=\"${INSTALL_DIR}\" >> ${ED}/${INSTALL_DIR}/.bashrc
	fowners -R nexus:nexus ${INSTALL_DIR}/.bashrc
	fperms 644 ${INSTALL_DIR}/.bashrc

	# patches
	sed -i "s/\.\.\/sonatype-work\/nexus3/\/var\/lib\/nexus/g" ${ED}/etc/nexus/nexus.vmoptions
}
