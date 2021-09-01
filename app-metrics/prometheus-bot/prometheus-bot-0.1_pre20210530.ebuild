# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

COMMIT="2dc161747f6a6ee8afbc8afd1b7e02f0bc195daf"

DESCRIPTION="Prometheus bot (telegram)"
HOMEPAGE="https://github.com/inCaller/prometheus_bot"
SRC_URI="https://github.com/inCaller/prometheus_bot/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"

DEPEND="acct-user/prometheus-bot"
RDEPEND="${DEPEND}"

EGO_SUM=(
	"github.com/aymerick/douceur v0.2.0"
	"github.com/aymerick/douceur v0.2.0/go.mod"
	"github.com/chris-ramon/douceur v0.2.0"
	"github.com/chris-ramon/douceur v0.2.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/gin-contrib/sse v0.1.0"
	"github.com/gin-contrib/sse v0.1.0/go.mod"
	"github.com/gin-gonic/gin v1.6.3"
	"github.com/gin-gonic/gin v1.6.3/go.mod"
	"github.com/go-playground/assert/v2 v2.0.1/go.mod"
	"github.com/go-playground/locales v0.13.0"
	"github.com/go-playground/locales v0.13.0/go.mod"
	"github.com/go-playground/universal-translator v0.17.0"
	"github.com/go-playground/universal-translator v0.17.0/go.mod"
	"github.com/go-playground/validator/v10 v10.2.0"
	"github.com/go-playground/validator/v10 v10.2.0/go.mod"
	"github.com/golang/protobuf v1.3.3"
	"github.com/golang/protobuf v1.3.3/go.mod"
	"github.com/google/gofuzz v1.0.0/go.mod"
	"github.com/gorilla/css v1.0.0"
	"github.com/gorilla/css v1.0.0/go.mod"
	"github.com/json-iterator/go v1.1.9/go.mod"
	"github.com/leodido/go-urn v1.2.0"
	"github.com/leodido/go-urn v1.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/microcosm-cc/bluemonday v1.0.4"
	"github.com/microcosm-cc/bluemonday v1.0.4/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
	"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/technoweenie/multipartstreamer v1.0.1"
	"github.com/technoweenie/multipartstreamer v1.0.1/go.mod"
	"github.com/ugorji/go v1.1.7"
	"github.com/ugorji/go v1.1.7/go.mod"
	"github.com/ugorji/go/codec v1.1.7"
	"github.com/ugorji/go/codec v1.1.7/go.mod"
	"golang.org/x/net v0.0.0-20181220203305-927f97764cc3"
	"golang.org/x/net v0.0.0-20181220203305-927f97764cc3/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/telegram-bot-api.v4 v4.6.4"
	"gopkg.in/telegram-bot-api.v4 v4.6.4/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
	"gopkg.in/yaml.v2 v2.3.0"
	"gopkg.in/yaml.v2 v2.3.0/go.mod"
)

go-module_set_globals
SRC_URI="
${SRC_URI}
${EGO_SUM_SRC_URI}
"

S="${WORKDIR}/prometheus_bot-${COMMIT}"

src_install() {
	newbin prometheus_bot prometheus-bot

	insinto "/etc/prometheus-bot"
	doins "${FILESDIR}/bot.yml"
	newins "${S}/testdata/default.tmpl" "bot.tmpl"

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	diropts -m0750 -o prometheus-bot -g prometheus-bot
	keepdir /var/log/prometheus-bot
}
