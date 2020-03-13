#!/bin/bash
# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Author: Ralph Sennhauser <sera@gentoo.org>

die() {
	echo "${@}"
	exit 1
}

usage() {
	cat <<EOL
Usage: ${BASH_SOURCE} <--create|--remove|--help> [--suffix s][--user u][--group g][--jmx [disabled|enabled --jmx_rmi_host host --jmx_port port --jmx_password password]]

  Options:
    --help:
      show this text.
    --create:
      create a new instance
    --remove:
      remove an existing instance.
    --suffix SUFFIX:
      a suffix for this instance. the suffix may not collide with an already
      existing instance, defaults to empty.
    --user USER:
      the user for which to configure this instance for. The user needs to
      exist already. defaults to jetty.
    --group GROUP:
      the group for which to configure this instance for. The group needs to
      exist already. defaults to jetty.
    --jmx [enabled|disabled]:
      enable or disable jmx support
    --jmx_port port
      port for jmx. default 1090
    --jmx_password password
      password to access jmx

  Examples:
    ${BASH_SOURCE} --create --suffix testing --user jetty2 --group jetty2
    ${BASH_SOURCE} --remove --suffix testing
EOL
}

parse_argv() {
	action="not specified"
	jmx="not specified"
	jmx_port=1090
	instance_name="jetty"
	instance_user="jetty"
	instance_group="jetty"

	while [[ -n $1 ]]; do
		case $1 in
			--help)
				usage
				exit 0;;
			--suffix)
				instance_name+="-$2"
				shift; shift;;
			--user)
				instance_user="$2"
				shift; shift;;
			--group)
				instance_group="$2"
				shift; shift;;
			--create)
				action=create
				shift;;
			--remove)
				action=remove
				shift;;
			--backup)
				action=backup
				shift;;
			--restore)
				action=restore
				shift;;
			--update)
				action=update
				shift;;
			--jmx)
				jmx="$2"
				shift; shift;
				if [ "$jmx" != "enabled" ] && [ "$jmx" != "disabled" ] && [ "$jmx" != "not specified" ]; then
					echo "Error: jmx invalid value '${jmx}'."
					exit 1;
				fi;;
			--jmx_rmi_host)
				jmx_rmi_host="$2"
				shift; shift;;
			--jmx_port)
				jmx_port="$2"
				shift; shift;;
			--jmx_password)
				jmx_password="$2"
				shift; shift;;
			*)
				echo "Invalid option '$1'"
				usage
				exit 2;;
		esac
	done

	jetty_home="/opt/jetty"
	instance_base="/var/lib/${instance_name}"
	instance_conf="/etc/${instance_name}"
	instance_logs="/var/log/${instance_name}"

	all_targets=(
		"${instance_base}"
		"${instance_logs}"
		"/etc/${instance_name}"
		"/etc/init.d/${instance_name}"
		"/etc/conf.d/${instance_name}"
	)
}
	
test_can_deploy() {
	local no_deploy target
	for target in "${all_targets[@]}"; do
		if [[ -e "${target}" ]]; then 
			echo "Error: '${target}' already exists."
			no_deploy=yes
		fi
	done
	if [[ -n "${no_deploy}" ]]; then
		cat <<-EOL

			To protect an existing installation no new instance was deployed. You can use
			'${BASH_SOURCE} --remove'
			to remove an existing instance first or run
			'${BASH_SOURCE} --create --sufix <instance_suffix>'
			to deploy an instance under a different name

		EOL
		usage
		exit 1
	fi

	if ! id --user "${instance_user}" >/dev/null 2>&1; then
		echo "Error: user '${instance_user}' doesn't exist."
		exit 1
	fi

	if ! id --group "${instance_group}" >/dev/null 2>&1; then
		echo "Error: group '${instance_group}' doesn't exist."
		exit 1
	fi
	
	if [[ `cat features` =~ "jmx=true" ]]; then
		case $jmx in
			"not specified")
				echo "Error: jmx feature exist. But attitude to jmx isn't specified"
				exit 1;;
			"disabled")
				# nothing todo
				;;
			"enabled")
				if [ -z "$jmx_password" ]; then
				    echo "Error: jmx feature enabled. But jmx_password ins't specified"
				    exit 1
				fi
				
				if [ -z "$jmx_rmi_host" ]; then
				    echo "Error: jmx feature enabled. But jmx_rmi_host ins't specified"
				    exit 1
				fi
				;;
			*)
				echo "Invalid jmx option '$jmx'"
				usage;;
		esac
	fi
}

deploy_instance() {
	test_can_deploy

	mkdir -p "${instance_base}"/{resources,webapps,lib/ext} || die
	mkdir -p "${instance_logs}" || die

	chown -R "${instance_user}":"${instance_group}" \
		"${instance_base}" "${instance_logs}" || die

	# initial config #

	cp -r "${jetty_home}"/gentoo/etc "${instance_conf}" || die

	# rc script #

	ln -s template.jetty "/etc/init.d/${instance_name}" || die

	sed -e "s|@INSTANCE_NAME@|${instance_name}|g" \
		-e "s|@INSTANCE_USER@|${instance_user}|g" \
		-e "s|@INSTANCE_GROUP@|${instance_group}|g" \
		"${jetty_home}"/gentoo/jetty.confd \
		> "/etc/conf.d/${instance_name}" || die

	ln -s "${instance_conf}" "${instance_base}"/etc || die
	ln -s "${instance_conf}"/start.ini "${instance_base}"/start.ini || die
	ln -s "${instance_conf}"/start.d "${instance_base}"/start.d || die
	ln -s "${instance_logs}" "${instance_base}"/logs || die

	# configure jmx
	
	if [ "$jmx" == "enabled" ]; then
		sed -i -e "s|#JETTY_JMX_PORT=@JETTY_JMX_PORT@|JETTY_JMX_PORT=${jmx_port}|g" \
			-e "s|#JETTY_RMI_HOST=@JETTY_RMI_HOST@|JETTY_RMI_HOST=${jmx_rmi_host}|g" \
			-e "s|#JETTY_JMX_HOST=localhost|JETTY_JMX_HOST=localhost|g" \
			"/etc/conf.d/${instance_name}" || die
		
		echo "monitorRole ${jmx_password}" > "${instance_conf}/jmx.password.file" || die
		echo "monitorRole readonly" > "${instance_conf}/jmx.access.file" || die
		
		sed -i -e "s|#--module=jmx-remote|--module=jmx-remote|g" "${instance_conf}/start.ini" || die
	fi
	
	# a note to update the default configuration #

	cat <<-EOL
		Successfully created instance '${instance_name}'
		It's strongly recommended for production systems to go carefully through the
		configuration files at '${instance_conf}'.
	EOL
}

remove_instance() {
	echo "The following files will be removed permanently:"
	local target; for target in "${all_targets[@]}"; do
		find ${target}
	done

	echo "Type 'yes' to continue"
	read
	if [[ ${REPLY} == yes ]]; then
		rm -rv "${all_targets[@]}"
	else 
		echo "Aborting as requested ..."
	fi
}

parse_argv "$@"

if [[ ${action} == create ]]; then
	deploy_instance
elif [[ ${action} == remove ]]; then
	remove_instance
elif [[ ${action} == "not specified" ]]; then
	echo "No action specified!"
	usage
	exit 1
else
	echo "${action} not yet implemented!"
	usage
	exit 1
fi
