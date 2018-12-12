.PHONY: all run restart rm stop build ssh

all: build run

run:
	docker-compose -p ssh -f docker-compose.yaml up -d

restart:
	docker-compose -p ssh -f docker-compose.yaml restart -t 0

rm: stop
	docker-compose -p ssh -f docker-compose.yaml rm -fv

stop:
	docker-compose -p ssh -f docker-compose.yaml stop -t 0

build:
	docker-compose -f docker-compose.yaml build

push:
	docker push gupalo/ssh:latest

ssh:
	docker exec -it ssh bash
