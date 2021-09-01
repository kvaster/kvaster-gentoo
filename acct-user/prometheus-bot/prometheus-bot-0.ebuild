# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for prometheus-bot service"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( prometheus-bot )

acct-user_add_deps
