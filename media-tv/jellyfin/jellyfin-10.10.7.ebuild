# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="The Free Software Media System"
HOMEPAGE="https://github.com/jellyfin/jellyfin"

if [[ ${PV} != 9999* ]] ; then
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/${PN}-${PV/_/-}"
else
	inherit git-r3
    EGIT_REPO_URI="https://github.com/${PN}/${PN}"
    EGIT_CHECKOUT_DIR="${WORKDIR}/${P}/src/${EGO_PN}"
	S="${WORKDIR}/${PN}-${PV/_/-}/src"
fi

LICENSE="GPL-2+"
SLOT="0"

RESTRICT="mirror network-sandbox"

DEPEND="!media-tv/jellyfin-bin"
RDEPEND="${DEPEND}
		=media-tv/jellyfin-web-${PV}
		acct-group/jellyfin
		acct-user/jellyfin
		media-video/ffmpeg[fontconfig,gmp,libass,drm,truetype,fribidi,vorbis,vdpau,vaapi,x264,x265,webp,bluray,zvbi,opus,theora]
		dev-db/sqlite:3
		media-libs/fontconfig
		media-libs/freetype
		dev-util/lttng-ust
		app-crypt/mit-krb5
		dev-libs/icu
		dev-libs/openssl"
BDEPEND="virtual/dotnet-sdk:8.0"

METAFILETOBUILD="MediaBrowser.sln"

src_compile() {
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	dotnet build --configuration Release Jellyfin.Server || die
	dotnet publish --configuration Release Jellyfin.Server --output ${S}/bin --self-contained --runtime linux-x64 || die
}

src_install() {
	insinto /etc/${PN}
	doins ${FILESDIR}/logging.json
	fowners -R "${PN}:${PN}" "/etc/${PN}"

	cp "${FILESDIR}/${PN}.conf.d" "${T}/${PN}.conf.d" || die
	cp "${FILESDIR}/${PN}.service.conf" "${T}/${PN}.service.conf" || die

	sed -i "s|/usr/lib/|/usr/$(get_libdir)/|g" \
		"${T}/${PN}.conf.d" \
		"${T}/${PN}.service.conf" || die

	newconfd "${T}/${PN}.conf.d" "${PN}"
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"

	systemd_install_serviced ${T}/${PN}.service.conf
	systemd_dounit ${FILESDIR}/${PN}.service

	keepdir "/var/lib/${PN}"
	fowners -R "${PN}:${PN}" "/var/lib/${PN}"

	keepdir "/var/log/${PN}"
	fowners -R "${PN}:${PN}" "/var/log/${PN}"

	keepdir "/var/cache/${PN}"
	fowners -R "${PN}:${PN}" "/var/cache/${PN}"

	insinto /usr/$(get_libdir)/${PN}/
	doins -r ${S}/bin
	fperms 0755 /usr/$(get_libdir)/${PN}/bin/${PN}

	dosym /usr/$(get_libdir)/${PN}/bin/${PN} /usr/bin/${PN}
}
