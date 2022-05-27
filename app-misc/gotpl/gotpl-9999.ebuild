# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module git-r3

EGIT_REPO_URI="https://github.com/ksa-real/gotpl.git"
EGIT_BRANCH="master"

RESTRICT="network-sandbox"

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Sprig command line tool"
HOMEPAGE="https://github.com/ksa-real/gotpl"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	go build
}

src_install() {
	newbin gotpl gotpl
}
