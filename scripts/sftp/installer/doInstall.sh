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
if [ ! -d /etc/ssh.template ] ; then
	cp -dpr /etc/ssh /etc/ssh.template
	(cd / && patch -p0 < "${BASEDIR}"/ssh-setup.patch)
fi

# Copying the template to /etc/ssh_chroot, and apply its patch
if [ ! -d /etc/ssh_chroot ] ; then
	cp -dpr /etc/ssh.template /etc/ssh_chroot
	(cd / && patch -p0 < "${BASEDIR}"/ssh_chroot-setup.patch)
fi

# Copying the service file to systemd
cp -p "${BASEDIR}"/sshd_chroot.service /etc/systemd/system
systemctl enable sshd_chroot
systemctl start sshd_chroot
