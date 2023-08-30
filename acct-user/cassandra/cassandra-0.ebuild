# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="A user for Cassandra database"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( cassandra )
ACCT_USER_HOME="/opt/cassandra"

acct-user_add_deps
