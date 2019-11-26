# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

#FV=${PV}
FV="3.6.0.16995A"

DESCRIPTION="Adobe FlexSDK"
HOMEPAGE="http://www.adobe.com/products/flex/"
SRC_URI="http://fpdownload.adobe.com/pub/flex/sdk/builds/flex3/flex_sdk_${FV}.zip"

SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-java/ant"

src_install() {
	epatch "${FILESDIR}"/effectmanager.patch
	cd ${WORKDIR}/frameworks
	ant framework || die

	mkdir -p ${D}/opt/flexsdk/${PV}
	cp -r ${WORKDIR}/* ${D}/opt/flexsdk/${PV}
}

