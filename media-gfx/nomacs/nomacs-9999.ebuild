# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils git-r3

DESCRIPTION="Qt-based image viewer"
HOMEPAGE="https://nomacs.org/"
EGIT_REPO_URI="https://github.com/nomacs/nomacs.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"
IUSE="+jpeg +opencv raw tiff zip heif"

REQUIRED_USE="
	raw? ( opencv )
	tiff? ( opencv )
"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg?]
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-gfx/exiv2:=
	opencv? ( >=media-libs/opencv-3.4:= )
	raw? ( media-libs/libraw:= )
	tiff? (
		dev-qt/qtimageformats:5
		media-libs/tiff:0
	)
	zip? ( dev-libs/quazip[qt5(+)] )
	heif? ( media-libs/libheif )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

S="${WORKDIR}/${P}/ImageLounge"

DOCS=( src/changelog.txt )

src_configure() {
	local mycmakeargs=(
		-DENABLE_CODE_COV=OFF
		-DUSE_SYSTEM_QUAZIP=ON
		-DENABLE_TRANSLATIONS=ON
		-DENABLE_OPENCV=$(usex opencv)
		-DENABLE_RAW=$(usex raw)
		-DENABLE_TIFF=$(usex tiff)
		-DENABLE_QUAZIP=$(usex zip)
		-DENABLE_HEIF=$(usex heif)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
