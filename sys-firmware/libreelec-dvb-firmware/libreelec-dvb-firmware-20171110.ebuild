# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="ac20a365c6df3af1a7c92a0195d443b8cf19cb9f"

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://github.com/LibreELEC/dvb-firmware/archive/${GIT_COMMIT}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/dvb-firmware-${GIT_COMMIT}"

src_install() {
	insinto /lib/firmware
	doins firmware/dvb-demod-m88ds3103.fw
}

