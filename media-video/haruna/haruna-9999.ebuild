# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://invent.kde.org/multimedia/${PN}.git"

inherit cmake git-r3 xdg

DESCRIPTION="Video player built with Qt/QML on top of libmpv"
HOMEPAGE="https://invent.kde.org/multimedia/haruna"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtdeclarative:6
	dev-qt/qtbase:6
	dev-libs/kdsingleapplication
	kde-frameworks/breeze-icons:6
	kde-frameworks/kconfig:6
	kde-frameworks/kcoreaddons:6
	kde-frameworks/kfilemetadata:6
	kde-frameworks/ki18n:6
	kde-frameworks/kiconthemes:6
	kde-frameworks/kio:6
	kde-apps/kio-extras:6
	kde-frameworks/kirigami:6
	kde-frameworks/kxmlgui:6
	kde-frameworks/qqc2-desktop-style:6
	media-libs/mpvqt
	net-misc/yt-dlp"
DEPEND="${RDEPEND}"
BDEPEND="kde-frameworks/extra-cmake-modules
	sys-devel/gettext"

src_configure() {
	local mycmakeargs=(
		-DKDE_INSTALL_DOCBUNDLEDIR="${EPREFIX}/usr/share/help"
	)
	cmake_src_configure
}

