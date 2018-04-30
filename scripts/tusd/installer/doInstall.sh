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

apt install -y golang
echo '# GOLANG ENV VARIABLES' >> /root/.bashrc
echo 'export GOROOT=/usr/lib/go' >> /root/.bashrc
export GOROOT=/usr/lib/go
echo 'export GOPATH=$HOME/go' >> /root/.bashrc
export GOPATH=$HOME/go
echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' >> /root/.bashrc
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

[ -d tusd ] || git clone https://github.com/tus/tusd.git
cd tusd
go get github.com/tus/tusd/cmd/tusd/cli
cd cmd/tusd
go build -o tusd
cp tusd /usr/bin/

# Copying the service file to systemd
if [ ! "$(systemctl is-active tusd.service)" = 'active' ]; then
	cp "${BASEDIR}"/tusd.service /etc/systemd/system
	systemctl enable tusd
	systemctl start tusd && echo "tusd daemon started successfully"
fi
