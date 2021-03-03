# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for VictoriaMetrics services"
ACCT_USER_ID="961"
ACCT_USER_GROUPS=( vmetrics )

acct-user_add_deps
