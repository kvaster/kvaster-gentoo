# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm kde.org git-r3

DESCRIPTION="MPV backend for the Phonon multimedia library"
HOMEPAGE="https://community.kde.org/Phonon"

#if [[ ${KDE_BUILD_TYPE} = release ]]; then
	EGIT_REPO_URI="https://github.com/OpenProgger/phonon-mpv"
	#S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
#fi

LICENSE="LGPL-2.1+ || ( LGPL-2.1 LGPL-3 )"
SLOT="0"
IUSE=""

DEPEND="
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=media-libs/phonon-4.11.0
	media-video/mpv
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DPHONON_BUILD_QT5=OFF
		-DPHONON_BUILD_QT6=ON
	)

	cmake_src_configure
}
