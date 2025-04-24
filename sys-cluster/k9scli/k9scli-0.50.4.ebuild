# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

# update this on every bump
GIT_COMMIT=e4e3816

DESCRIPTION="terminal based UI to manage kubernetes clusters"
HOMEPAGE="https://k9scli.io"
SRC_URI="
	https://github.com/derailed/k9s/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://gentoo.kvaster.com/godeps/${P}-vendor.tar.zst
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"

S="${WORKDIR}/k9s-${PV}"

src_unpack() {
	default
	zstd -dc $(readlink -f "${DISTDIR}/${P}-vendor.tar.zst") | tar -xC ${S} || die
}

src_prepare() {
	default
	# I will look into opening an upstream PR to do this.
	sed -i -e 's/-w -s -X/-X/' Makefile || die
}

src_compile() {
	emake GIT_REV=${GIT_COMMIT} VERSION=v${PV} build
}

src_install() {
	dobin execs/k9s
	dodoc -r change_logs plugins skins README.md
}
