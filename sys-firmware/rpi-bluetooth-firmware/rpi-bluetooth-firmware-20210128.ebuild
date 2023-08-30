# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="e7fd166981ab4bb9a36c2d1500205a078a35714d"

DESCRIPTION="Bluetooth firmware for rpi3 and rpi4"
HOMEPAGE="https://github.com/RPi-Distro/bluez-firmware"

SRC_URI="https://github.com/RPi-Distro/bluez-firmware/archive/$COMMIT.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

S="${WORKDIR}/bluez-firmware-${COMMIT}"

SLOT="0"
KEYWORDS="amd64 arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto /lib/firmware/brcm
	doins broadcom/BCM4345C0.hcd
	doins broadcom/BCM43430A1.hcd
}

