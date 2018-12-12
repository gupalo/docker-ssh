SSH Image
=========

Useful for providing limited SSH access to containers of some project of docker network.

Build
-----

    make build
    make push

Use in real project
-------------------

Example:

    $ cat /opt/important_service/docker-compose.yml
    version: '2'
    services:
        db_important_service:
            container_name: db_important_service
            image: mariadb
            environment:
                - MYSQL_DATABASE=important_service
                - MYSQL_ROOT_PASSWORD=xxxxxxxx
                - TZ=UTC
            restart: always
            volumes:
                - ./mysql_important_service/:/var/lib/mysql/
            networks: ['mysql']
        db_ssh:
            image: gupalo/ssh
            container_name: db_ssh
            restart: 'always'
            networks: ['mysql']
            volumes:
                - './ssh/:/root/.ssh/'
            ports:
                - '10.x.x.xxx:xxxxx:22'
    ...

**Note:** `db_important_service` and `db_ssh` should have at least one common network.

Add user keys to `ssh/authorized_keys`.

Then users can connect "via ssh 10.x.x.xxx:xxxxx" to host "db_important_service" and will have no
access to other services of this server.
