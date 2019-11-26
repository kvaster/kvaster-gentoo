# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/inCaller"
GOLANG_PKG_NAME="prometheus_bot"
GOLANG_PKG_VERSION="37679806b449b3012f2a17ed1462ccca542a40aa"
GOLANG_PKG_HAVE_TEST=0

GOLANG_PKG_DEPENDENCIES=(
	"github.com/gin-gonic/gin:678e09c"
	"github.com/gin-contrib/sse:22d885f"
	"github.com/go-telegram-bot-api/telegram-bot-api:9c39935 -> gopkg.in/telegram-bot-api.v4"
	"github.com/go-yaml/yaml:51d6538 -> gopkg.in/yaml.v2"
	"github.com/golang/protobuf:1d3f30b"
	"github.com/manucorporat/sse:ee05b12"
	"github.com/mattn/go-isatty:3fb116b"
	"github.com/technoweenie/multipartstreamer:a90a01d"
	"github.com/golang/net:e147a91 -> golang.org/x"
	"github.com/go-playground/validator:5f1438d -> gopkg.in/go-playground/validator.v8"
	"github.com/ugorji/go:772ced7"
)

inherit user golang-single

DESCRIPTION="Prometheus bot (telegram)"
HOMEPAGE="https://github.com/inCaller/prometheus_bot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DAEMON_USER="prometheus-bot"
DAEMON_GROUP=${DAEMON_USER}
LOG_DIR="/var/log/prometheus-bot"
DATA_DIR="/var/lib/prometheus-bot"

pkg_setup() {
	enewgroup ${DAEMON_GROUP}
	enewuser ${DAEMON_USER} -1 -1 -1 ${DAEMON_GROUP}
}

src_install() {
	golang-common_src_install

	insinto "/etc/prometheus-bot"
	doins "${FILESDIR}/bot.yml"
	newins "${S}/testdata/default.tmpl" "bot.tmpl"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	keepdir "${LOG_DIR}"
	fowners "${DAEMON_USER}":"${DAEMON_GROUP}" "${LOG_DIR}"
}

