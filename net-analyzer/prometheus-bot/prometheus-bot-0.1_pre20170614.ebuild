# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/inCaller"
GOLANG_PKG_NAME="prometheus_bot"
GOLANG_PKG_VERSION="1e865738a0d4565f59fa25a60fc2e143dc19a604"
GOLANG_PKG_HAVE_TEST=0

GOLANG_PKG_DEPENDENCIES=(
	"github.com/gin-gonic/gin:d5b353c"
	"github.com/go-telegram-bot-api/telegram-bot-api:0a57807"
	"github.com/go-yaml/yaml:cd8b52f -> gopkg.in/yaml.v2"
	"github.com/golang/protobuf:6a1fa94"
	"github.com/manucorporat/sse:ee05b12"
	"github.com/mattn/go-isatty:fc9e8d8"
	"github.com/technoweenie/multipartstreamer:a90a01d"
	"github.com/golang/net:d997483 -> golang.org/x"
	"github.com/go-playground/validator:5f57d22 -> gopkg.in/go-playground/validator.v8"
)

inherit user golang-single

DESCRIPTION="Prometheus bot (telegram)"
HOMEPAGE="https://github.com/inCaller/prometheus_bot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/date_format.patch"
)

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

