#!/sbin/openrc-run
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

description="Jellyfin Media Server"

user="${JELLYFIN_USER}:${JELLYFIN_USER}"

start_stop_daemon_args="--user $user --wait 10"

command="/usr/bin/jellyfin"
command_args="--configdir $JELLYFIN_CONFIG_DIR
	--datadir $JELLYFIN_DATA_DIR
	--cachedir $JELLYFIN_CACHE_DIR
	--logdir $JELLYFIN_LOG_DIR
	$JELLYFIN_ARGS"

command_background="true"

pidfile="/run/jellyfin.pid"

depend() {
	need net
    	after bootmisc
}

start_pre() {
    checkpath --directory --owner $user $JELLYFIN_CONFIG_DIR
    checkpath --directory --owner $user $JELLYFIN_DATA_DIR
    checkpath --directory --owner $user $JELLYFIN_CACHE_DIR
    checkpath --directory --owner $user $JELLYFIN_LOG_DIR
}
