# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Bluetooth firmware for rpi3 and rpi4"
HOMEPAGE="https://github.com/RPi-Distro/bluez-firmware"

EGIT_REPO_URI="https://github.com/RPi-Distro/bluez-firmware.git"
EGIT_COMMIT="e7fd166"

SLOT="0"
KEYWORDS="arm64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	insinto /lib/firmware/brcm
	doins broadcom/BCM4345C0.hcd
	doins broadcom/BCM43430A1.hcd
}

