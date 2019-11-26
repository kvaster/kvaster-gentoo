# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils git-r3 linux-info systemd toolchain-funcs user

DESCRIPTION="Tvheadend is a TV streaming server and digital video recorder"
HOMEPAGE="https://tvheadend.org/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ccache capmt constcw +cwc dbus +dvb +dvbscan epoll ffmpeg hdhomerun libav +iconv imagecache inotify iptv satip +timeshift uriparser xmltv zeroconf zlib en50221"

RDEPEND="dev-libs/openssl:=
	ccache? ( dev-util/ccache sys-libs/zlib )
	dbus? ( sys-apps/dbus )
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3:= )
		libav? ( media-video/libav:= )
	)
	hdhomerun? ( media-libs/libhdhomerun )
	iconv? ( virtual/libiconv )
	imagecache? ( net-misc/curl )
	uriparser? ( dev-libs/uriparser )
	zeroconf? ( net-dns/avahi )
	zlib? ( sys-libs/zlib )
	dvb? ( media-libs/libdvbcsa )"

DEPEND="${RDEPEND}
	dvb? ( virtual/linuxtv-dvb-headers )
	capmt? ( virtual/linuxtv-dvb-headers )
	virtual/pkgconfig"

RDEPEND+="
	dvbscan? ( media-tv/linuxtv-dvb-apps )
	xmltv? ( media-tv/xmltv )"

CONFIG_CHECK="~INOTIFY_USER"

DOCS=( README.md )

pkg_setup() {
	enewuser tvheadend -1 -1 /dev/null video
}

src_prepare() {
	eapply_user
	# remove '-Werror' wrt bug #438424
	sed -e 's:-Werror::' -i Makefile || die 'sed failed!'
	epatch "${FILESDIR}/adapter_id.patch"
}

src_configure() {
	econf --prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		$(use_enable ccache) \
		$(use_enable capmt) \
		$(use_enable constcw) \
		$(use_enable cwc) \
		$(use_enable dbus) \
		$(use_enable dvb linuxdvb) \
		$(use_enable epoll) \
		--disable-kqueue \
		$(use_enable ffmpeg libav) \
		$(use_enable hdhomerun hdhomerun_client) \
		$(use_enable imagecache) \
		$(use_enable inotify) \
		$(use_enable iptv) \
		$(use_enable satip satip_server) \
		$(use_enable satip satip_client) \
		$(use_enable timeshift) \
		$(use_enable uriparser) \
		$(use_enable zeroconf avahi) \
		$(use_enable zlib) \
		$(use_enable en50221) \
		--disable-hdhomerun_static \
		--disable-ffmpeg_static \
		--disable-libx264_static \
		--disable-libx265_static \
		--disable-libvpx_static \
		--disable-libtheora_static \
		--disable-libvorbis_static \
		--disable-libfdkaac_static \
		--disable-libmfx_static \
		--disable-dvbscan
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	newinitd "${FILESDIR}/tvheadend.initd" tvheadend
	newconfd "${FILESDIR}/tvheadend.confd" tvheadend

	systemd_dounit "${FILESDIR}/tvheadend.service"

	dodir /etc/tvheadend
	fperms 0700 /etc/tvheadend
	fowners tvheadend:video /etc/tvheadend
}

pkg_postinst() {
	elog "The Tvheadend web interface can be reached at:"
	elog "http://localhost:9981/"
	elog
	elog "Make sure that you change the default username"
	elog "and password via the Configuration / Access control"
	elog "tab in the web interface."
}
