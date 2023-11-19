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

clean:
	rm -rf scripts
	rm -rf rules
	rm -rf services
