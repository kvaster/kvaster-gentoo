# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Environment for installing Open Handset Alliance's Android SDK"
HOMEPAGE="https://developer.android.com"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="acct-group/android"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

ANDROID_SDK_DIR="/opt/android-sdk"

#EF="${T}/80${PN}"
EF="${T}/49${PN}"

src_install() {
	keepdir "${ANDROID_SDK_DIR}"
	fowners -R root:android "${ANDROID_SDK_DIR}"
	fperms -R 0775 "${ANDROID_SDK_DIR}"

	TOOLS="${EPREFIX}${ANDROID_SDK_DIR}/tools"
	TOOLS_BIN="${EPREFIX}${ANDROID_SDK_DIR}/tools/bin"
	PLATFORM_TOOLS="${EPREFIX}${ANDROID_SDK_DIR}/platform-tools"
	CMDLINE_TOOLS="${EPREFIX}${ANDROID_SDK_DIR}/cmdline-tools/latest/bin"

	echo "PATH=\"${TOOLS}:${TOOLS_BIN}:${PLATFORM_TOOLS}:${CMDLINE_TOOLS}\"" > "${EF}" || die
	echo "ANDROID_HOME=\"${EPREFIX}${ANDROID_SDK_DIR}\"" >> "${EF}" || die
	doenvd "${EF}"

	insinto "/etc/revdep-rebuild" && doins "${EF}"
	udev_dorules "${FILESDIR}"/80-android.rules || die
}

pkg_postinst() {
	elog "The Android SDK now uses its own manager for the development  environment."
	elog "Run android studio or sdkmanager (from dev-utils/android-cmdlinetools)"
	elog "to download the full SDK, including platform tools."
	elog "You must be in the android group to manage the development environment."
	elog "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
}
