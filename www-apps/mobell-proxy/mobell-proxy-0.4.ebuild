# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user go-module

KEYWORDS="~amd64"

DESCRIPTION="Mobel proxy is a companion for mobell android app and mobotix cameras"
HOMEPAGE="https://github.com/kvaster/mobell-proxy"

LICENSE="Apache-2.0"
SLOT="0"

EGO_VENDOR=(
	"github.com/apex/log v1.1.1"
	"github.com/pkg/errors v0.8.1"
)

SRC_URI="https://github.com/kvaster/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

pkg_setup() {
	enewgroup mobell-proxy
	enewuser mobell-proxy -1 -1 /var/lib/mobell-proxy mobell-proxy
}

src_compile() {
    go build
}

src_install() {
    newbin mobell-proxy mobell-proxy

    diropts -m0750 -o mobell-proxy -g mobell-proxy
    keepdir /var/log/mobell-proxy /var/lib/mobell-proxy

    newinitd "${FILESDIR}"/mobell-proxy.initd mobell-proxy
    newconfd "${FILESDIR}"/mobell-proxy.confd mobell-proxy
}
