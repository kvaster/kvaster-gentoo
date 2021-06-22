# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal usr-ldscript git-r3 autotools

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="https://libusb.info/ https://github.com/libusb/libusb"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS=""
IUSE="debug doc examples static-libs test udev"
RESTRICT="!test? ( test )"

RDEPEND="udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP},static-libs(-)?] )"
DEPEND="${RDEPEND}
	!udev? ( virtual/os-headers )"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable udev)
		$(use_enable debug debug-log)
		$(use_enable test tests-build)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi; then
		use doc && emake -C doc
	fi
}

multilib_src_test() {
	emake check

	# noinst_PROGRAMS from tests/Makefile.am
	tests/stress || die
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		gen_usr_ldscript -a usb-1.0

		use doc && dodoc -r doc/api-1.0
	fi
}

multilib_src_install_all() {
	find "${ED}" -type f -name "*.la" -delete || die

	dodoc AUTHORS ChangeLog NEWS PORTING README TODO

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h}
	fi
}
