# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for mobell-proxy service"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( mobell-proxy )

acct-user_add_deps
