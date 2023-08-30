# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="9556b08ace2a1735127894642cc8ea6529c04c90"

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

