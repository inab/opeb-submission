#!/bin/sh
cd /tmp/
if [ ! -d bats ]; then
	apt install -y git
	git clone https://github.com/sstephenson/bats
	cd  bats
	./install.sh /usr/local
	cd ..
fi
cd ..

