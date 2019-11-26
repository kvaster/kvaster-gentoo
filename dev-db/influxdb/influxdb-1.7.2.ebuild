# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Change this when you update the ebuild
GIT_COMMIT="76f907b0fada2f16931e37471da695349fcdf8c6"
EGO_PN="github.com/influxdata/${PN}"
EGO_VENDOR=(
	# Note: Keep EGO_VENDOR in sync with Gopkg.lock
	"collectd.org 2ce144541b89 github.com/collectd/go-collectd"
	"github.com/BurntSushi/toml a368813c5e64"
	#"github.com/Masterminds/semver v1.4.2"
	"github.com/RoaringBitmap/roaring v0.4.16"
	#"github.com/alecthomas/kingpin v2.2.6"
	#"github.com/alecthomas/template a0175ee3bccc"
	#"github.com/alecthomas/units 2efee857e7cf"
	#"github.com/apex/log 941dea75d3eb"
	#"github.com/aws/aws-sdk-go v1.15.50"
	"github.com/beorn7/perks 3a771d992973"
	#"github.com/blakesmith/ar 8bd4349a67f2"
	"github.com/bmizerany/pat 6226ea591a40"
	"github.com/boltdb/bolt v1.3.1"
	"github.com/c-bata/go-prompt v0.2.1"
	#"github.com/caarlos0/ctrlc v1.0.0"
	#"github.com/campoy/unique 88950e537e7e"
	"github.com/cespare/xxhash v1.0.0"
	#"github.com/davecgh/go-spew v1.1.0"
	"github.com/dgrijalva/jwt-go v3.2.0"
	"github.com/dgryski/go-bitstream 3522498ce2c8"
	"github.com/fatih/color v1.5.0"
	"github.com/glycerine/go-unsnap-stream 9f0cb55181dd"
	#"github.com/go-ini/ini v1.38.3"
	"github.com/go-sql-driver/mysql v1.4.0"
	"github.com/gogo/protobuf v1.1.1"
	"github.com/golang/protobuf v1.1.0"
	"github.com/golang/snappy d9eb7a3d35ec"
	#"github.com/google/go-cmp v0.2.0"
	#"github.com/google/go-github dd29b543e14c"
	#"github.com/google/go-querystring v1.0.0"
	#"github.com/goreleaser/goreleaser v0.88.0"
	#"github.com/goreleaser/nfpm v0.9.5"
	#"github.com/imdario/mergo v0.3.6"
	"github.com/influxdata/flux v0.7.1"
	"github.com/influxdata/influxql c661ab7db8ad"
	"github.com/influxdata/line-protocol 32c6aa80de5e"
	"github.com/influxdata/platform dc5616e3f9ed"
	"github.com/influxdata/roaring fc520f41fab6"
	"github.com/influxdata/tdigest a7d76c6f093a"
	"github.com/influxdata/usage-client 6d3895376368"
	#"github.com/jmespath/go-jmespath 0b12d6b521d8"
	"github.com/jsternberg/zap-logfmt v1.0.0"
	"github.com/jwilder/encoding b4e1701a28ef"
	#"github.com/kevinburke/go-bindata v3.11.0"
	#"github.com/kisielk/gotool v1.0.0"
	"github.com/klauspost/compress v1.4.0"
	"github.com/klauspost/cpuid v1.1"
	"github.com/klauspost/crc32 v1.1"
	"github.com/klauspost/pgzip v1.1"
	"github.com/lib/pq v1.0.0"
	#"github.com/mattn/go-colorable v0.0.9"
	"github.com/mattn/go-isatty 6ca4dbf54d38"
	"github.com/mattn/go-runewidth v0.0.2"
	#"github.com/mattn/go-tty 13ff1204f104"
	#"github.com/mattn/go-zglob 2ea3427bfa53"
	"github.com/matttproud/golang_protobuf_extensions v1.0.1"
	#"github.com/mitchellh/go-homedir ae18d6b8b320"
	#"github.com/mna/pigeon v1.0.0"
	#"github.com/mschoch/smat 90eadee771ae"
	"github.com/opentracing/opentracing-go bd9c31933947"
	#"github.com/paulbellamy/ratecounter v0.2.0"
	"github.com/peterh/liner 8c1271fcf47f"
	"github.com/philhofer/fwd v1.0.0"
	"github.com/pkg/errors v0.8.0"
	"github.com/pkg/term bffc007b7fd5"
	"github.com/prometheus/client_golang 661e31bf844d"
	"github.com/prometheus/client_model 5c3871d89910"
	"github.com/prometheus/common 7600349dcfe1"
	"github.com/prometheus/procfs ae68e2d4c00f"
	"github.com/retailnext/hllpp 101a6d2f8b52"
	"github.com/satori/go.uuid v1.2.0"
	"github.com/segmentio/kafka-go v0.2.0"
	"github.com/tinylib/msgp 1.0.2"
	#"github.com/willf/bitset v1.1.3"
	"github.com/xlab/treeprint d6fb6747feb6"
	"go.uber.org/atomic v1.3.2 github.com/uber-go/atomic"
	"go.uber.org/multierr v1.1.0 github.com/uber-go/multierr"
	"go.uber.org/zap v1.9.0 github.com/uber-go/zap"
	"golang.org/x/crypto a2144134853f github.com/golang/crypto"
	"golang.org/x/net a680a1efc54d github.com/golang/net"
	#"golang.org/x/oauth2 c57b0facaced github.com/golang/oauth2"
	"golang.org/x/sync 1d60e4601c6f github.com/golang/sync"
	"golang.org/x/sys ac767d655b30 github.com/golang/sys"
	"golang.org/x/text v0.3.0 github.com/golang/text"
	"golang.org/x/time fbb02b2291d2 github.com/golang/time"
	#"golang.org/x/tools 45ff765b4815 github.com/golang/tools"
	#"google.golang.org/appengine v1.2.0 github.com/golang/appengine"
	"google.golang.org/genproto fedd2861243f github.com/google/go-genproto"
	"google.golang.org/grpc v1.13.0 github.com/grpc/grpc-go"
	#"gopkg.in/yaml.v2 5420a8b6744d github.com/go-yaml/yaml"
	#"honnef.co/go/tools 2017.2.2 github.com/dominikh/go-tools"
)

inherit golang-vcs-snapshot-r1 systemd user

MY_PV="${PV/_/}"
DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="https://influxdata.com"
ARCHIVE_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="${ARCHIVE_URI} ${EGO_VENDOR_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug man pie"

DEPEND="man? ( app-text/asciidoc app-text/xmlto )"

QA_PRESTRIPPED="usr/bin/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_setup() {
	enewgroup influxdb
	enewuser influxdb -1 -1 /var/lib/influxdb influxdb
}

src_prepare() {
	# By default InfluxDB sends anonymous statistics to
	# usage.influxdata.com. Let's sed-fix to disable it.
	sed -i "s:# reporting.*:reporting-disabled = true:" \
		etc/config.sample.toml || die

	default
}

src_compile() {
	export GOPATH="${G}"
	export GOBIN="${S}"
	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "main.branch=non-git"
		-X "main.commit=${GIT_COMMIT:0:7}"
		-X "main.version=${MY_PV}"
	)
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie exe)"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)
	go install "${mygoargs[@]}" ./cmd/influx{,d,_inspect,_stress,_tools,_tsm} || die

	use man && emake -C man
}

src_test() {
	go test -v -timeout 10s ./cmd/influxd/run || die
}

src_install() {
	dobin influx{,d,_inspect,_stress,_tools,_tsm}
	use debug && dostrip -x /usr/bin/influx{,d,_inspect,_stress,_tools,_tsm}

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
	systemd_dounit "scripts/${PN}.service"

	insinto /etc/influxdb
	newins etc/config.sample.toml influxdb.conf.example

	use man && doman man/*.1

	diropts -o influxdb -g influxdb -m 0750
	keepdir /var/log/influxdb
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/etc/influxdb/influxdb.conf" ]]; then
		elog "No influxdb.conf found, copying the example over"
		cp "${EROOT}"/etc/influxdb/influxdb.conf{.example,} || die
	else
		elog "influxdb.conf found, please check example file for possible changes"
	fi
}
