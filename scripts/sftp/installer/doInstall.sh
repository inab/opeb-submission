#!/bin/bash

BASEDIR="$(dirname "$0")"
case "$BASEDIR" in
	/*)
		true
		;;
	*)
		BASEDIR="${PWD}/${BASEDIR}"
		;;
esac

# Creating the templating directory
if [ ! -d /etc/ssh ] ; then
	cp -dpr /etc/ssh.template /etc/ssh
fi

# Copying the template to /etc/ssh_chroot, and apply its patch
if [ ! -d /etc/ssh_chroot ] ; then
	if [ -d /etc/ssh.template ] ; then
		cp -dpr /etc/ssh.template /etc/ssh_chroot
	else
		cp -dpr /etc/ssh /etc/ssh_chroot
	fi
fi

if grep -Fq '#------- Next line added automatically by the sftp installer -------' '/etc/ssh/sshd_config'; then
	echo "'/etc/ssh/sshd_config' was already patched correctly"
else
	(cd / && sed -f "${BASEDIR}"/ssh-setup.sed -i /etc/ssh/sshd_config) && \
		echo "'/etc/ssh/sshd_config' patched correctly"
fi

if grep -Fq '#------- Next lines added automatically by the sftp installer -------' '/etc/ssh_chroot/sshd_config'; then
	echo "'/etc/ssh_chroot/sshd_config' was already patched correctly"
else
	(cd / && sed -f "${BASEDIR}"/ssh_chroot-setup.sed -i /etc/ssh_chroot/sshd_config) && \
		echo "'/etc/ssh_chroot/sshd_config' patched correctly"
fi

# Copying the service file to systemd
if [ ! $(systemctl is-active sshd_chroot.service) = 'active' ]; then
	cp -p "${BASEDIR}"/sshd_chroot.service /etc/systemd/system
	systemctl enable sshd_chroot
	systemctl start sshd_chroot && echo "sshd_chroot daemon started successfully"
fi
