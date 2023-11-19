all: scripts rules services

scripts:
	./create-scripts.sh

rules:
	./create-rules.sh

services:
	./create-services.sh

install:

clean:
	rm -rf scripts
	rm -rf rules
	rm -ef services