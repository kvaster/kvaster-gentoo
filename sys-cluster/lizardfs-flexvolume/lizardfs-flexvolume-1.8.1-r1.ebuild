# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Lizardfs kubernetes flexvolume driver"
HOMEPAGE="https://github.com/kvaster/lizardfs-flexvolume"
SRC_URI="https://github.com/kvaster/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"

DEPEND="
	app-misc/jq
	sys-cluster/lizardfs[fuse3]"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	exeinto /usr/libexec/kubernetes/kubelet-plugins/volume/exec/fq~lizardfs/
	doexe lizardfs
}

