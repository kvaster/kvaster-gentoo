# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Change this when you update the ebuild
GIT_COMMIT="533c7bb3e5847db423387abfcf983e3f947818eb"
WEBAPP_COMMIT="36854bc12b1cf845ccad6bc8ddf9e46065a5b392"
EGO_PN="github.com/mattermost/${PN}"
WEBAPP_P="mattermost-webapp-${PV}"
MY_PV="${PV/_/-}"

if [[ "$ARCH" != "x86" && "$ARCH" != "amd64" ]]; then
	INHERIT="autotools"
	DEPEND="media-libs/libpng:0"
fi

inherit ${INHERIT} golang-vcs-snapshot-r1 systemd user

DESCRIPTION="Open source Slack-alternative in Golang and React (Team Edition)"
HOMEPAGE="https://mattermost.com"
SRC_URI="
	https://${EGO_PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
	https://${EGO_PN/server/webapp}/archive/v${MY_PV}.tar.gz -> ${WEBAPP_P}.tar.gz
"
RESTRICT="mirror test"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86" # Untested: arm64 x86
IUSE="+audit debug pie static"

DEPEND="${DEPEND}
	>net-libs/nodejs-6[npm]
"
RDEPEND="!www-apps/mattermost-server-ee"

QA_PRESTRIPPED="usr/libexec/.*"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_pretend() {
	if [[ "${MERGE_TYPE}" != binary ]]; then
		# shellcheck disable=SC2086
		if has network-sandbox ${FEATURES}; then
			ewarn
			ewarn "${CATEGORY}/${PN} requires 'network-sandbox' to be disabled in FEATURES"
			ewarn
			die "[network-sandbox] is enabled in FEATURES"
		fi

		if use audit && [[ $(npm --version) != 6.* ]]; then
			ewarn
			ewarn "npm v6 is required to run 'npm audit', which is a new command that"
			ewarn "performs security reports and tries to fix known vulnerabilities"
			ewarn
		fi
	fi
}

pkg_setup() {
	enewgroup mattermost
	enewuser mattermost -1 -1 -1 mattermost
}

src_unpack() {
	golang-vcs-snapshot-r1_src_unpack
	cd "${S}" || die
	unpack "${WEBAPP_P}.tar.gz"
	mv "${WEBAPP_P/_/-}" client || die
}

src_prepare() {
	local datadir="${EPREFIX}/var/lib/mattermost"
	# Disable developer settings, fix path, set to listen localhost
	# and disable diagnostics (call home) by default.
	# shellcheck disable=SC2086
	#sed -i \
	#	-e 's|\("ListenAddress":\).*\(8065\).*|\1 "127.0.0.1:\2",|' \
	#	-e 's|\("ListenAddress":\).*\(8067\).*|\1 "127.0.0.1:\2"|' \
	#	-e 's|\("ConsoleLevel":\).*|\1 "INFO",|' \
	#	-e 's|\("EnableDiagnostics":\).*|\1 false|' \
	#	-e 's|\("Directory":\).*\(/data/\).*|\1 "'${datadir}'\2",|g' \
	#	-e 's|\("Directory":\).*\(/plugins\).*|\1 "'${datadir}'\2",|' \
	#	-e 's|\("ClientDirectory":\).*\(/client/plugins\).*|\1 "'${datadir}'\2",|' \
	#	-e 's|tcp(dockerhost:3306)|unix(/run/mysqld/mysqld.sock)|' \
	#	config/default.json || die

	# Reset email sending to original configuration
	#sed -i \
	#	-e 's|\("SendEmailNotifications":\).*|\1 false,|' \
	#	-e 's|\("FeedbackEmail":\).*|\1 "",|' \
	#	-e 's|\("SMTPServer":\).*|\1 "",|' \
	#	-e 's|\("SMTPPort":\).*|\1 "",|' \
	#	config/default.json || die

	# shellcheck disable=SC1117
	# Remove the git call, as the tarball isn't a proper git repository
	sed -i \
		-E "s/^(\s*)COMMIT_HASH:(.*),$/\1COMMIT_HASH: JSON.stringify\(\"${WEBAPP_COMMIT}\)\"\),/" \
		client/webpack.config.js || die

	default
}

src_compile() {
	export GOPATH="${G}"
	export GOBIN="${S}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"
	(use static && ! use pie) && export CGO_ENABLED=0
	(use static && use pie) && CGO_LDFLAGS+=" -static"

	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "${EGO_PN}/model.BuildNumber=${PV}"
		-X "'${EGO_PN}/model.BuildDate=$(date -u)'"
		-X "${EGO_PN}/model.BuildHash=${GIT_COMMIT}"
		-X "${EGO_PN}/model.BuildHashEnterprise=none"
		-X "${EGO_PN}/model.BuildEnterpriseReady=false"
	)

	local mygoargs=(
		-v -work -x
		-buildmode "$(usex pie pie exe)"
		-asmflags "all=-trimpath=${S}"
		-gcflags "all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
		-tags "$(usex static 'netgo' '')"
		-installsuffix "$(usex static 'netgo' '')"
	)

	pushd client > /dev/null || die
	emake build
	if use audit && [[ $(npm --version) =~ 6.* ]]; then
		ebegin "Attempting to fix potential vulnerabilities"
		npm audit fix --package-lock-only
		eend $? || die
	fi
	popd > /dev/null || die

	go install "${mygoargs[@]}" ./cmd/{mattermost,platform} || die
}

src_install() {
	exeinto /usr/libexec/mattermost/bin
	doexe {mattermost,platform}
	use debug && dostrip -x /usr/libexec/mattermost/bin/{mattermost,platform}

	newinitd "${FILESDIR}/${PN}.initd-r2" "${PN}"
	systemd_newunit "${FILESDIR}/${PN}.service-r1" "${PN}.service"

	insinto /etc/mattermost
	doins config/README.md
	#doins config/default.json
	#newins config/default.json config.json
	#fowners mattermost:mattermost /etc/mattermost/config.json
	#  fperms 600 /etc/mattermost/config.json

	insinto /usr/share/mattermost
	doins -r {fonts,i18n,templates}

	#insinto /usr/share/mattermost/config
	#doins config/timezones.json

	insinto /usr/share/mattermost/client
	doins -r client/dist/*

	diropts -o mattermost -g mattermost -m 0750
	keepdir /var/{lib,log}/mattermost
	keepdir /var/lib/mattermost/client

	dosym ../libexec/mattermost/bin/mattermost /usr/bin/mattermost
	dosym ../../../../etc/mattermost/config.json /usr/libexec/mattermost/config/config.json
	dosym ../../../share/mattermost/config/timezones.json /usr/libexec/mattermost/config/timezones.json
	dosym ../../share/mattermost/fonts /usr/libexec/mattermost/fonts
	dosym ../../share/mattermost/i18n /usr/libexec/mattermost/i18n
	dosym ../../share/mattermost/templates /usr/libexec/mattermost/templates
	dosym ../../share/mattermost/client /usr/libexec/mattermost/client
	dosym ../../../var/log/mattermost /usr/libexec/mattermost/logs
}
