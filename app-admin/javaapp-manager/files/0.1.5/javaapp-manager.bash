#!/bin/bash

die() {
    echo "${@}"
    exit 1
}

usage() {
    cat <<EOL
Usage: ${BASH_SOURCE} --create <service name>

  Options:
    --help
      show this text
    --create
      create new java application
    --remove
      remove existing java application
    --force
      force application remove (do not ask)
    
    MEM param can be defined in usual way (i.e. 64m, 2G) or may be set to 'auto'
        in auto mode memory will be configured to use all available memory on host
EOL
}

parse_argv() {
    action="no action"
    name=""

    while [[ -n $1 ]]; do
        case $1 in
            --help)
                usage
                exit 0;;
            --create)
                action=create
                name="$2"
                shift; shift;;
            --remove)
                action=remove
                name="$2"
                shift; shift;;
            --force)
                force="true"
                shift;;
            *)
                echo "Invalid option '$1'"
                usage
                exit 2;;
        esac
    done
    
    targets=(
        /etc/init.d/${name}
        /etc/conf.d/${name}
        /var/log/${name}
        /var/lib/${name}
        /opt/${name}
    )
}

create_app() {
    for target in "${targets[@]}"; do
        if [[ -e "${target}" ]]; then 
            echo "warning: '${target}' already exists."
            no_deploy=yes
        fi
    done
    
    if [[ -n "${no_deploy}" ]]; then
        cat <<-EOL
  To protect an existing installation no new instance was deployed. You can use
  '${BASH_SOURCE} --remove'
  to remove an existing instance first
EOL
        usage
        exit 1
    fi
    
    useradd -M ${name} || die
    
    mkdir -p /var/log/${name} /var/lib/${name} /opt/${name} || die
    chown ${name}:${name} -R /var/log/${name} /var/lib/${name} || die
    
    ln -s javaapp.template /etc/init.d/${name}
    
    cp "$(readlink -f $(dirname ${BASH_SOURCE}))/confd"  "/etc/conf.d/${name}"
}

remove_app() {
    echo "User ${name}, group ${name} and following files will be removed permanently:"
    local target; for target in "${targets[@]}"; do
        find ${target}
    done
    
    if [[ ! "${force}" == "true" ]]; then
        echo "Type 'yes' to continue"
        read
        if [[ ! ${REPLY} == "yes" ]]; then
            echo "Aborting as requested..."
            exit 1
        fi
    fi
    
    rm -rv "${targets[@]}"
    userdel ${name}
}

parse_argv "$@"

if [[ ${action} == create ]]; then
    create_app
elif [[ ${action} == remove ]]; then
    remove_app
elif [[ ${action} == "no action" ]]; then
    echo "No action specified!"
    usage
    exit 1
else
    echo "${action} not yet implemented!"
    usage
    exit 1
fi
