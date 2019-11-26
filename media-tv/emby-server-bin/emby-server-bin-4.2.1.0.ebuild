# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils user unpacker

DESCRIPTION="Emby Server (formerly known as MediaBrowser Server) is a software that indexes a lot of different kinds of media and allows for them to be retrieved and played through the DLNA protocol on any device capable of processing them."
HOMEPAGE="http://emby.media/"
KEYWORDS="~*"
SRC_URI="https://github.com/MediaBrowser/Emby.Releases/releases/download/${PV}/emby-server-deb_${PV}_amd64.deb"

SLOT="0"
LICENSE="GPL-2"
IUSE=""
RESTRICT="mirror test"

RDEPEND=">=dev-dotnet/dotnetcore-sdk-bin-2.1
	>=media-video/ffmpeg-2[vpx]
	media-gfx/imagemagick[jpeg,jpeg2k,webp,png]
	>=dev-db/sqlite-3.0.0
	dev-libs/openssl:1.0.0"
DEPEND="${RDEPEND} sys-apps/debianutils"

S=${WORKDIR}

INSTALL_DIR="/opt/emby-server"
DATA_DIR="/var/lib/emby-server"
STARTUP_LOG="/var/log/emby-server_start.log"

pkg_setup() {
	enewgroup emby
	enewuser emby -1 /bin/bash ${INSTALL_DIR} "emby"
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	newinitd "${FILESDIR}"/emby-server.init emby-server
	newconfd "${FILESDIR}"/emby-server.conf emby-server

	dodir /var/log/
	touch ${D}${STARTUP_LOG}
	chown emby:emby ${D}${STARTUP_LOG}

	keepdir ${DATA_DIR}
	fowners emby:emby ${DATA_DIR}

	insinto ${INSTALL_DIR}
	doins -r opt/emby-server/system/*
	fperms +x ${INSTALL_DIR}/EmbyServer
}

