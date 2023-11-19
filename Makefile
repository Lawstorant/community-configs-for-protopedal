all: scripts rules services

scripts:
	./create-scripts.sh

rules:
	./create-rules.sh

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
	rm -ef services