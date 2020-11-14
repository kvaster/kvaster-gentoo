# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="A user for the Jellyfin Media Server"
ACCT_USER_ID="960"
ACCT_USER_GROUPS=( jellyfin )
ACCT_USER_HOME="/var/lib/jellyfin"

acct-user_add_deps
