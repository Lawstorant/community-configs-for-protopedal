all: scripts rules services

scripts:
	src/create-scripts.sh

rules:
	src/create-udev-rules.sh $(group)

services:
	src/create-services.sh

install:
	mv output/scripts/*  /usr/bin/
	mv output/rules/*    /etc/udev/rules.d/
	mv output/services/* /etc/systemd/system/

uninstall:
	rm /usr/bin/protopedal-*.sh
	rm /etc/udev/rules.d/99-protopedal-*.rule
	rm /etc/systemd/system/protopedal-*.service

clean:
	rm -rf output
