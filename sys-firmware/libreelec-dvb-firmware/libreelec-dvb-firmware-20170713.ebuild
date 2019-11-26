# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GIT_COMMIT="c91bab0210ef74af0090e7bda121dd628f32511a"

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

