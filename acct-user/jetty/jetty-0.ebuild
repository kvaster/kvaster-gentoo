# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for Jetty application server"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( jetty )

ACCT_USER_SHELL=/bin/bash
ACCT_USER_HOME=/opt/jetty
ACCT_USER_HOME_OWNER=jetty:jetty

acct-user_add_deps
