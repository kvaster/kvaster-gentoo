# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="Open Handset Alliance's Android SDK command line tools"
HOMEPAGE="https://developer.android.com"

SRC_URI="https://dl.google.com/android/repository/commandlinetools-linux-${PV}_latest.zip"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="dev-util/android-sdk-base"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

ANDROID_SDK_DIR="/opt/android-sdk"

src_install() {
	CMDLINE_TOOLS="${EPREFIX}${ANDROID_SDK_DIR}/cmdline-tools/${PV}/bin"

	echo "PATH=\"${CMDLINE_TOOLS}\"" > "${T}/81${PN}" || die
	doenvd "${T}/81${PN}"

	insinto "/etc/revdep-rebuild" && doins "${T}/81${PN}"

	insinto "${ANDROID_SDK_DIR}/cmdline-tools/${PV}"
	insopts
	doins -r "${S}/cmdline-tools"/*
}

