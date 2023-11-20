all: scripts rules services

scripts:
	./create-scripts.sh

rules:
	./create-udev-rules.sh $(group)

services:
	./create-services.sh

install:
	mv scripts/*  /usr/bin/
	mv rules/*    /etc/udev/rules.d/
	mv services/* /etc/systemd/system/

uninstall:
	rm /usr/bin/protopedal-*.sh
	rm /etc/udev/rules.d/99-protopedal-*.rule
	rm /etc/systemd/system/protopedal-*.service

clean:
	rm -rf scripts
	rm -rf rules
	rm -rf services
