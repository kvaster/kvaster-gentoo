# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Network UPS Tools (NUT) Prometheus Exporter"
HOMEPAGE="https://github.com/DRuggeri/nut_exporter"

LICENSE="Apache-2.0"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~arm64"

EGO_SUM=(
	"github.com/alecthomas/kingpin/v2 v2.3.2"
	"github.com/alecthomas/kingpin/v2 v2.3.2/go.mod"
	"github.com/alecthomas/units v0.0.0-20211218093645-b94a6e3cc137"
	"github.com/alecthomas/units v0.0.0-20211218093645-b94a6e3cc137/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/cespare/xxhash/v2 v2.1.2"
	"github.com/cespare/xxhash/v2 v2.1.2/go.mod"
	"github.com/coreos/go-systemd/v22 v22.5.0"
	"github.com/coreos/go-systemd/v22 v22.5.0/go.mod"
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/go-kit/log v0.2.1"
	"github.com/go-kit/log v0.2.1/go.mod"
	"github.com/go-logfmt/logfmt v0.5.1"
	"github.com/go-logfmt/logfmt v0.5.1/go.mod"
	"github.com/godbus/dbus/v5 v5.0.4/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/golang/protobuf v1.3.1/go.mod"
	"github.com/golang/protobuf v1.3.5/go.mod"
	"github.com/golang/protobuf v1.5.0/go.mod"
	"github.com/golang/protobuf v1.5.2"
	"github.com/golang/protobuf v1.5.2/go.mod"
	"github.com/google/go-cmp v0.5.5/go.mod"
	"github.com/google/go-cmp v0.5.9"
	"github.com/jpillora/backoff v1.0.0"
	"github.com/jpillora/backoff v1.0.0/go.mod"
	"github.com/kr/pretty v0.3.1"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/matttproud/golang_protobuf_extensions v1.0.4"
	"github.com/matttproud/golang_protobuf_extensions v1.0.4/go.mod"
	"github.com/mwitkow/go-conntrack v0.0.0-20190716064945-2f068394615f"
	"github.com/mwitkow/go-conntrack v0.0.0-20190716064945-2f068394615f/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/prometheus/client_golang v1.14.0"
	"github.com/prometheus/client_golang v1.14.0/go.mod"
	"github.com/prometheus/client_model v0.3.0"
	"github.com/prometheus/client_model v0.3.0/go.mod"
	"github.com/prometheus/common v0.41.0"
	"github.com/prometheus/common v0.41.0/go.mod"
	"github.com/prometheus/exporter-toolkit v0.9.2-0.20230325130527-feef77d71811"
	"github.com/prometheus/exporter-toolkit v0.9.2-0.20230325130527-feef77d71811/go.mod"
	"github.com/prometheus/procfs v0.9.0"
	"github.com/prometheus/procfs v0.9.0/go.mod"
	"github.com/robbiet480/go.nut v0.0.0-20220219091450-bd8f121e1fa1"
	"github.com/robbiet480/go.nut v0.0.0-20220219091450-bd8f121e1fa1/go.mod"
	"github.com/rogpeppe/go-internal v1.9.0"
	"github.com/rogpeppe/go-internal v1.9.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.8.2"
	"github.com/xhit/go-str2duration/v2 v2.1.0"
	"github.com/xhit/go-str2duration/v2 v2.1.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.7.0"
	"golang.org/x/crypto v0.7.0/go.mod"
	"golang.org/x/net v0.0.0-20190603091049-60506f45cf65/go.mod"
	"golang.org/x/net v0.8.0"
	"golang.org/x/net v0.8.0/go.mod"
	"golang.org/x/oauth2 v0.6.0"
	"golang.org/x/oauth2 v0.6.0/go.mod"
	"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
	"golang.org/x/sync v0.1.0"
	"golang.org/x/sync v0.1.0/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.6.0"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/text v0.8.0"
	"golang.org/x/text v0.8.0/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"golang.org/x/xerrors v0.0.0-20191204190536-9bdfabe68543/go.mod"
	"google.golang.org/appengine v1.6.7"
	"google.golang.org/appengine v1.6.7/go.mod"
	"google.golang.org/protobuf v1.26.0-rc.1/go.mod"
	"google.golang.org/protobuf v1.26.0/go.mod"
	"google.golang.org/protobuf v1.28.1"
	"google.golang.org/protobuf v1.28.1/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20201130134442-10cb98267c6c"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.4.0"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
)

go-module_set_globals

SRC_URI="
https://github.com/DRuggeri/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
${EGO_SUM_SRC_URI}
"

src_compile() {
	go build
}

src_install() {
	newbin nut_exporter nut_exporter

	newinitd "${FILESDIR}"/nut_exporter.initd nut_exporter
	newconfd "${FILESDIR}"/nut_exporter.confd nut_exporter
}

