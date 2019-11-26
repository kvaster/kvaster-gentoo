#!/bin/bash

die() {
    echo "${@}"
    exit 1
}

usage() {
    cat <<EOL
Usage: ${BASH_SOURCE} --create <service name> [--jmx <port>] --web <hostname:port>  [--mem-min m] [--mem-max m] [--mem-new m] [--mem-default]

  Options:
    --help
      show this text
    --create
      create new java application
    --remove
      remove existing java application
    --mem-min MEM
      configure application java min memory
    --mem-max MEM
      configure application java max memory
    --mem-new MEM
      configure application java new memory
    --mem-default
      set application java memory to default values (usefull for local small apps)
    --force
      force application remove (do not ask)
    --jmx <port>
      The port to connect to via remote JMX to localhost. Default value is 5590
    --web <hostname:port>
      The host and port to expose metrics
    
    <service-name> must be without postfix. Postfix "-exporter" will be added automatically.
    MEM param can be defined in usual way (i.e. 64m, 2G)
EOL
}

parse_argv() {
    action="no action"
    mem_min_p="#"
    mem_min="32m"
    mem_max_p="#"
    mem_max="256m"
    mem_new_p="#"
    mem_new="32m"
    jmx_port="5590"

    while [[ -n $1 ]]; do
        case $1 in
            --help)
                usage
                exit 0;;
            --create)
                action=create
                if [[ -z "$2" ]]; then
                    echo "<service name> isn't specified"
                    usage
                    exit 1
                fi
                name="$2-exporter"
                shift; shift;;
            --remove)
                action=remove
                if [[ -z "$2" ]]; then
                    echo "<service name> isn't specified"
                    usage
                    exit 1
                fi
                name="$2-exporter"
                shift; shift;;
            --mem-min)
                mem_min_p=""
                mem_min="$2"
                shift; shift;;
            --mem-max)
                mem_max_p=""
                mem_max="$2"
                shift; shift;;
            --mem-new)
                mem_new_p=""
                mem_new="$2"
                shift; shift;;
            --mem-default)
                mem_min_p=""
                mem_max_p=""
                mem_new_p=""
                shift;;
            --force)
                force="true"
                shift;;
            --jmx)
                jmx_port="$2";
                shift; shift;;
            --web)
                web_host_port="$2";
                shift; shift;;
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
        /opt/${name}
    )
}

create_app() {
    if [[ -z "$web_host_port" ]]; then
        echo "web isn't specified"
        usage
        exit 1
    fi

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
    
    ln -s jmxexporter.template /etc/init.d/${name}
    
    sed -e "s|@mem_min_p@|${mem_min_p}|g" \
        -e "s|@mem_min@|${mem_min}|g" \
        -e "s|@mem_max_p@|${mem_max_p}|g" \
        -e "s|@mem_max@|${mem_max}|g" \
        -e "s|@mem_new_p@|${mem_new_p}|g" \
        -e "s|@mem_new@|${mem_new}|g" \
        -e "s|@host_port@|${web_host_port}|g" \
        $(readlink -f $(dirname ${BASH_SOURCE}))/confd > /etc/conf.d/${name}
    
    sed -e "s|@port@|${jmx_port}|g" \
        $(readlink -f $(dirname ${BASH_SOURCE}))/config.yml > /opt/${name}/config.yml
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
