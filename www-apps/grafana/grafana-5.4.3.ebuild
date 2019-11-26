# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Change this when you update the ebuild
GIT_COMMIT="653918056c594d7f56a65771b2c9681bdf8a3b9a"
EGO_PN="github.com/${PN}/${PN}"
MY_PV="${PV/_/-}"

inherit golang-vcs-snapshot-r1 systemd user

DESCRIPTION="Grafana is an open source metric analytics & visualization suite"
HOMEPAGE="https://grafana.com"
SRC_URI="https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug pie"

RDEPEND="!www-apps/grafana-bin"
DEPEND="
	>=net-libs/nodejs-8.12.0
	sys-apps/yarn
"

DOCS=( CHANGELOG.md README.md )
QA_EXECSTACK="usr/libexec/grafana/phantomjs"
QA_PRESTRIPPED="${QA_EXECSTACK} usr/bin/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_pretend() {
	# shellcheck disable=SC2086
	if has network-sandbox ${FEATURES} && [[ "${MERGE_TYPE}" != binary ]]; then
		ewarn
		ewarn "${CATEGORY}/${PN} requires 'network-sandbox' to be disabled in FEATURES"
		ewarn
		die "[network-sandbox] is enabled in FEATURES"
	fi
}

pkg_setup() {
	enewgroup grafana
	enewuser grafana -1 -1 /usr/share/grafana grafana
}

src_compile() {
	export GOPATH="${G}"
	export GOBIN="${S}/bin"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "main.version=${MY_PV}"
		-X "main.commit=${GIT_COMMIT:0:7}"
		-X "main.buildstamp=$(date -u '+%s')"
		-X "main.buildBranch=non-git"
	)
	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie exe)"
		-asmflags "all=-trimpath=${S}"
		-gcflags "all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
	)
	emake deps
	go install "${mygoargs[@]}" ./pkg/cmd/grafana-{cli,server} || die
	emake build-js
}

src_test() {
	emake test-go test-js
}

src_install() {
	dobin bin/grafana-{cli,server}
	use debug && dostrip -x /usr/bin/grafana-{cli,server}
	einstalldocs

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"

	exeinto /usr/libexec/grafana
	doexe tools/phantomjs/phantomjs

	insinto /etc/grafana
	newins conf/sample.ini grafana.ini.example

	insinto /usr/share/grafana/conf
	doins conf/{defaults.ini,ldap.toml}

	insinto /usr/share/grafana
	doins -r public

	insinto /usr/share/grafana/tools/phantomjs
	doins tools/phantomjs/render.js
	dosym ../../../../libexec/grafana/phantomjs \
		/usr/share/grafana/tools/phantomjs/phantomjs

	diropts -o grafana -g grafana -m 0750
	keepdir /var/log/grafana
	keepdir /var/lib/grafana/{dashboards,plugins}
}

pkg_postinst() {
	if [[ ! -e "${EROOT}/etc/grafana/grafana.ini" ]]; then
		elog "No grafana.ini found, copying the example over"
		cp "${EROOT}"/etc/grafana/grafana.ini{.example,} || die
	else
		elog "grafana.ini found, please check example file for possible changes"
	fi

	einfo
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "${EROOT}/etc/grafana/grafana.ini for related settings."
	elog ""
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
	einfo
}
