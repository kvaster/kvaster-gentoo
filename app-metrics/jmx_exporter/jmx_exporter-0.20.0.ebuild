# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

KEYWORDS="~amd64 ~x86"

DESCRIPTION="A process for exposing JMX Beans via HTTP for Prometheus consumption"
HOMEPAGE="https://github.com/prometheus/jmx_exporter"
SRC_URI="https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_httpserver/${PV}/jmx_prometheus_httpserver-${PV}.jar"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
S="${WORKDIR}"

RDEPEND=">=virtual/jdk-1.8"

DEPEND=">=virtual/jdk-1.8"

INSTALL_DIR="/opt/jmx_exporter"

src_install() {
        newinitd ${FILESDIR}/${PV}/initd jmxexporter.template
        
        insinto "${INSTALL_DIR}"
        doins ${FILESDIR}/${PV}/confd
        doins ${FILESDIR}/${PV}/config.yml
        
        exeinto "${INSTALL_DIR}"
        doexe ${FILESDIR}/${PV}/jmx-exporter-manager.bash
        
        make_wrapper jmxexporter-manager "${INSTALL_DIR}/jmx-exporter-manager.bash"
        
        java-pkg_jarinto "${INSTALL_DIR}"
        java-pkg_newjar "${DISTDIR}/jmx_prometheus_httpserver-${PV}-jar-with-dependencies.jar"
}
