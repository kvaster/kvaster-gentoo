# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="Mobel proxy is a companion for mobell android app and mobotix cameras"
HOMEPAGE="https://github.com/kvaster/mobell-proxy"

LICENSE="Apache-2.0"
SLOT="0"

EGO_SUM=(
	"github.com/apex/log v1.1.1"
	"github.com/apex/log v1.1.1/go.mod"
	"github.com/aphistic/golf v0.0.0-20180712155816-02c07f170c5a/go.mod"
	"github.com/aphistic/sweet v0.2.0/go.mod"
	"github.com/aws/aws-sdk-go v1.20.6/go.mod"
	"github.com/aybabtme/rgbterm v0.0.0-20170906152045-cc83f3b3ce59/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/fatih/color v1.7.0"
	"github.com/fatih/color v1.7.0/go.mod"
	"github.com/fsnotify/fsnotify v1.4.7/go.mod"
	"github.com/go-logfmt/logfmt v0.4.0"
	"github.com/go-logfmt/logfmt v0.4.0/go.mod"
	"github.com/golang/protobuf v1.2.0/go.mod"
	"github.com/google/uuid v1.1.1/go.mod"
	"github.com/hpcloud/tail v1.0.0/go.mod"
	"github.com/jmespath/go-jmespath v0.0.0-20180206201540-c2b33e8439af/go.mod"
	"github.com/jpillora/backoff v0.0.0-20180909062703-3050d21c67d7/go.mod"
	"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515/go.mod"
	"github.com/mattn/go-colorable v0.1.1/go.mod"
	"github.com/mattn/go-colorable v0.1.2"
	"github.com/mattn/go-colorable v0.1.2/go.mod"
	"github.com/mattn/go-isatty v0.0.5/go.mod"
	"github.com/mattn/go-isatty v0.0.8"
	"github.com/mattn/go-isatty v0.0.8/go.mod"
	"github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b/go.mod"
	"github.com/onsi/ginkgo v1.6.0/go.mod"
	"github.com/onsi/gomega v1.5.0/go.mod"
	"github.com/pkg/errors v0.8.1"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rogpeppe/fastuuid v1.1.0/go.mod"
	"github.com/sergi/go-diff v1.0.0/go.mod"
	"github.com/smartystreets/assertions v1.0.0/go.mod"
	"github.com/smartystreets/go-aws-auth v0.0.0-20180515143844-0c1422d1fdb9/go.mod"
	"github.com/smartystreets/gunit v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/tj/assert v0.0.0-20171129193455-018094318fb0/go.mod"
	"github.com/tj/go-elastic v0.0.0-20171221160941-36157cbbebc2/go.mod"
	"github.com/tj/go-kinesis v0.0.0-20171128231115-08b17f58cb1b/go.mod"
	"github.com/tj/go-spin v1.1.0/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20190426145343-a29dc8fdc734/go.mod"
	"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20190620200207-3b0461eec859/go.mod"
	"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
	"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190222072716-a9d3bda3a223/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
	"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
)

go-module_set_globals

SRC_URI="
https://github.com/kvaster/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
${EGO_SUM_SRC_URI}
"

DEPEND="acct-user/mobell-proxy"
RDEPEND="${DEPEND}"

src_compile() {
	go build
}

src_install() {
	newbin mobell-proxy mobell-proxy

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}

	diropts -m0750 -o mobell-proxy -g mobell-proxy
	keepdir /var/log/${PN}

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
