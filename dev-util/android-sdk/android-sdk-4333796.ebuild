# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user udev

DESCRIPTION="Open Handset Alliance's Android SDK"
HOMEPAGE="https://developer.android.com"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

SRC_URI="https://dl.google.com/android/repository/sdk-tools-linux-${PV}.zip"

DEPEND="app-arch/tar
        app-arch/gzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

ANDROID_SDK_DIR="/opt/${PN}"

pkg_setup() {
    enewgroup android
}

src_install() {
    dodir "${ANDROID_SDK_DIR}"
    fowners -R root:android "${ANDROID_SDK_DIR}"
    fperms -R 0775 "${ANDROID_SDK_DIR}"
    
    echo "PATH=\"${EPREFIX}${ANDROID_SDK_DIR}/tools:${EPREFIX}${ANDROID_SDK_DIR}/platform-tools\"" > "${T}/80${PN}" || die
    echo "ANDROID_HOME=\"${EPREFIX}${ANDROID_SDK_DIR}\"" >> "${T}/80${PN}" || die
    doenvd "${T}/80${PN}"
    
    insinto "/etc/revdep-rebuild" && doins "${T}/80${PN}"
    udev_dorules "${FILESDIR}"/80-android.rules || die
}

pkg_postinst() {
    if [[ ! -e "${ANDROID_SDK_DIR}/tools" ]]; then
        elog "Detected new install. Unpacking sdk tools."
        cp -r "${S}/tools" "${ANDROID_SDK_DIR}"
        chown -R root:android "${ANDROID_SDK_DIR}"
        chmod -R 0775 "${ANDROID_SDK_DIR}"
    fi

    elog "The Android SDK now uses its own manager for the development  environment."
    elog "Run 'sdkmanager' or android studio to download the full SDK, including some of the platform tools."
    elog "You must be in the android group to manage the development environment."
    elog "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
}
