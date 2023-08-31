# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit wrapper

DESCRIPTION="Java Application Manager"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
S="${WORKDIR}"

src_install() {
	newinitd ${FILESDIR}/${PV}/initd javaapp.template

	insinto /opt/javaapp-manager
	doins ${FILESDIR}/${PV}/confd

	exeinto /opt/javaapp-manager
	doexe ${FILESDIR}/${PV}/javaapp-manager.bash

	make_wrapper javaapp-manager /opt/javaapp-manager/javaapp-manager.bash
}

