# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# This ebuild come from bangert overlay

EAPI=8

inherit wrapper

JMX_PRO_JA_VER="0.20.0"

VER="${PV/_/-}"
VER_NS=${VER%-*}

DESCRIPTION="Cassandra"
HOMEPAGE="http://cassandra.apache.org/"
SRC_URI="https://archive.apache.org/dist/cassandra/${VER_NS}/apache-cassandra-${VER}-bin.tar.gz
	https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/${JMX_PRO_JA_VER}/jmx_prometheus_javaagent-${JMX_PRO_JA_VER}.jar"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
CDEPEND="acct-group/cassandra
	acct-user/cassandra"
DEPEND=">=virtual/jdk-1.8
	app-arch/unzip
	dev-java/java-config
	dev-java/jna
	${CDEPEND}"
RDEPEND=">=virtual/jdk-1.8
	dev-java/jna
	dev-libs/jemalloc
	${CDEPEND}"

S="${WORKDIR}"/apache-cassandra-${VER}

CONF="5"
CASSANDRA_HOME="/opt/cassandra"

TOOLS="cassandra
nodetool
cqlsh
debug-cql
sstableutil
sstableloader
sstablescrub
sstableupgrade
sstableverify"

TOOLS2="sstabledump
sstableexpiredblockers
sstablelevelreset
sstablemetadata
sstableofflinerelevel
sstablerepairedset
sstablesplit
"

src_compile() {
	sed -i '/cassandra_storagedir=/c\cassandra_storagedir="${CASSANDRA_STORAGE:-$CASSANDRA_HOME\/data}"' "${S}/bin/cassandra.in.sh"
	return
}

src_install() {
	echo ${S}

	newinitd "${FILESDIR}"/${CONF}/cassandra.initd cassandra
	newconfd "${FILESDIR}"/${CONF}/cassandra.confd cassandra

	insinto /etc/cassandra
	doins -r conf/*

	rm -rf conf

	dodir ${CASSANDRA_HOME}
	dosym /etc/cassandra ${CASSANDRA_HOME}/conf
	dosym /var/log/cassandra ${CASSANDRA_HOME}/logs
	dosym /var/lib/cassandra ${CASSANDRA_HOME}/data

	insinto ${CASSANDRA_HOME}
	doins -r .

	exeinto ${CASSANDRA_HOME}/bin
	for tool in $TOOLS
	do
		doexe bin/${tool}
	done

	exeinto ${CASSANDRA_HOME}/tools/bin
	for tool in $TOOLS2
	do
		doexe tools/bin/${tool}
	done

	fowners -R cassandra:cassandra ${CASSANDRA_HOME}

	keepdir /var/log/cassandra
	fowners cassandra:cassandra /var/log/cassandra

	keepdir /var/lib/cassandra
	fowners cassandra:cassandra /var/lib/cassandra

	for tool in $TOOLS
	do
		make_wrapper $tool "${CASSANDRA_HOME}/bin/${tool}"
	done

	for tool in $TOOLS2
	do
		make_wrapper $tool "${CASSANDRA_HOME}/tools/bin/${tool}"
	done

	# Add /jmx_prometheus_javaagent
	doins ${DISTDIR}/jmx_prometheus_javaagent-${JMX_PRO_JA_VER}.jar
}
