# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GST_ORG_MODULE=gst-plugins-bad

inherit flag-o-matic gstreamer-meson

DESCRIPTION="AAC audio decoder plugin."
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="+orc +introspection"

RDEPEND=">=media-libs/faad2-2.7-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

multilib_src_configure() {
	local emesonargs=(
		$(meson_feature orc)
		-Dintrospection=$(multilib_native_usex introspection enabled disabled)
	)

	gstreamer_multilib_src_configure
}
