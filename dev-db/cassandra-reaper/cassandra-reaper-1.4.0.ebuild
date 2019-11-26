# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user java-pkg-2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Tool that aims to schedule and orchestrate repairs of Apache Cassandra clusters"
HOMEPAGE="https://github.com/thelastpickle/cassandra-reaper"
SRC_URI="https://bintray.com/thelastpickle/reaper-tarball/download_file?file_path=cassandra-reaper-1.4.0-release.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND=">=virtual/jdk-1.8"

DEPEND=">=virtual/jdk-1.8"

INSTALL_DIR="/opt/cassandra-reaper"

pkg_setup() {
        enewgroup ${PN}
        enewuser ${PN} -1 -1 -1 ${PN}
}

src_install() {

        newinitd ${FILESDIR}/${PV}/initd ${PN}
        newconfd ${FILESDIR}/${PV}/confd ${PN}
        
        #insinto "${INSTALL_DIR}"
        #doins ${FILESDIR}/${PV}/confd
        #doins ${FILESDIR}/${PV}/config.yml
        
        java-pkg_jarinto "${INSTALL_DIR}"
        java-pkg_newjar "${S}/server/target/cassandra-reaper-${PV}.jar"
        
        keepdir /var/log/${PN}
        fowners ${PN}:${PN} /var/log/${PN}
        
        dodir /etc/${PN}
        insinto /etc/${PN}
        newins ${FILESDIR}/${PV}/cassandra-reaper.yaml config.yml
}
