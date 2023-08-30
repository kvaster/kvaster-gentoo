# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for Nexus repository manager"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( nexus )

ACCT_USER_SHELL=/bin/bash
ACCT_USER_HOME=/opt/nexus
ACCT_USER_HOME_OWNER=nexus:nexus

acct-user_add_deps
