# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="RNNoise is a noise suppression library based on a recurrent neural network."
HOMEPAGE="https://github.com/xiph/rnnoise"

EGIT_REPO_URI="https://github.com/xiph/rnnoise.git"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	eautoreconf
}

