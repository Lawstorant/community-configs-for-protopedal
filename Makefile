all: scripts rules services

scripts:
	src/create-scripts.sh

rules:
	src/create-udev-rules.sh $(group)

services:
	src/create-services.sh

install:
	cp output/scripts/*  /usr/bin/
	cp output/rules/*    /etc/udev/rules.d/
	cp output/services/* /etc/systemd/system/

uninstall:
	rm /usr/bin/protopedal-*.sh
	rm /etc/udev/rules.d/99-protopedal-*.rule
	rm /etc/systemd/system/protopedal-*.service

clean:
	rm -rf output
