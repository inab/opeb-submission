#! /usr/bin/env bash
pushd /tmp/ > /dev/null
if [ ! -d bats ]; then
	apt install -y git
	git clone https://github.com/sstephenson/bats
	pushd bats
	./install.sh /usr/local
	popd
fi > /dev/null
popd  > /dev/null

