# Jellyfin default configuration options
# This is a POSIX shell fragment

# Use this file to override the default configurations; add additional
# options with JELLYFIN_ADD_OPTS.
#JELLYFIN_ADD_OPTS=""

# Program directories
JELLYFIN_DATA_DIR="/var/lib/jellyfin"
JELLYFIN_CONFIG_DIR="/etc/jellyfin"
JELLYFIN_LOG_DIR="/var/log/jellyfin"
JELLYFIN_CACHE_DIR="/var/cache/jellyfin"

# [OPTIONAL] run Jellyfin as a headless service
#JELLYFIN_SERVICE_OPT="--service"

# [OPTIONAL] run Jellyfin without the web app
#JELLYFIN_NOWEBAPP_OPT="--noautorunwebapp"

# Application username
JELLYFIN_USER="jellyfin"
# Full application command
JELLYFIN_ARGS="$JELLYFIN_SERVICE_OPT $JELLFIN_NOWEBAPP_OPT $JELLYFIN_ADD_OPTS"
