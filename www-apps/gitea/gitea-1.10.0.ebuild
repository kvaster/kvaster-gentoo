# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps golang-build golang-vcs-snapshot systemd user

EGO_PN="code.gitea.io/gitea"
KEYWORDS="~amd64"

DESCRIPTION="A painless self-hosted Git service, written in Go"
HOMEPAGE="https://gitea.io/"
SRC_URI="https://github.com/go-gitea/gitea/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"

DEPEND="
	dev-go/go-bindata
	sys-libs/pam
"
RDEPEND="
	dev-vcs/git[curl,threads]
	sys-libs/pam
"

FILECAPS=( cap_net_bind_service+ep usr/bin/gitea )

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitea git
}

src_prepare() {
	default
	sed -i -e "s/\"main.Version.*$/\"main.Version=${PV}\"/"\
		-e "s/-ldflags '-s/-ldflags '/" src/${EGO_PN}/Makefile || die
}

src_compile() {
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C src/${EGO_PN} generate
	TAGS="bindata pam sqlite" LDFLAGS="" CGO_LDFLAGS="" GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" emake -C src/${EGO_PN} build
}

src_install() {
	diropts -m0750 -o git -g git
	keepdir /var/log/gitea /var/lib/gitea /var/lib/gitea/data
	pushd src/${EGO_PN} || die
	dobin gitea
	insinto /var/lib/gitea/conf
	newins custom/conf/app.ini.sample app.ini.example
	popd || die
	newinitd "${FILESDIR}"/gitea.initd gitea
	newconfd "${FILESDIR}"/gitea.confd gitea
	keepdir /var/log/gitea /var/lib/gitea/data
	systemd_dounit "${FILESDIR}/gitea.service"
}

pkg_postinst() {
	fcaps_pkg_postinst
	if [[ ! -e "${EROOT}/var/lib/gitea/conf/app.ini" ]]; then
		elog "No app.ini found, copying initial config over"
		cp "${FILESDIR}"/app.ini "${EROOT}"/var/lib/gitea/conf/ || die
		chown git:git /var/lib/gitea/conf/app.ini
		elog "Please make sure that your 'git' user has the correct homedir (/var/lib/gitea)."
	else
		elog "app.ini found, please check example file for possible changes"
		ewarn "Please note that environment variables have been changed:"
		ewarn "GITEA_WORK_DIR is set to /var/lib/gitea (previous value: unset)"
		ewarn "GITEA_CUSTOM is set to '\$GITEA_WORK_DIR/custom' (previous: /var/lib/gitea)"
	fi
}
