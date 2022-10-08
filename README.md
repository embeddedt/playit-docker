# playit-docker

![Docker Pulls](https://img.shields.io/docker/pulls/embeddedt/playit)

Simple Docker image that allows the [playit.gg](https://playit.gg/) agent to be
used in a Docker container.

This is intended to be used by server admins already using a Dockerized Minecraft
server. Most casual users are probably better off running the playit agent directly.

## Example usage with Docker Compose and [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server)

1. Create `docker-compose.yml` with the following contents:

```yaml
version: "3"

services:
  mc:
    image: itzg/minecraft-server
    networks:
      serverbridge:
        ipv4_address: 10.1.0.2
    expose:
      - 25565
    environment:
      EULA: "TRUE"
      VERSION: "1.12.2"
    tty: true
    stdin_open: true
    restart: unless-stopped
    volumes:
      - "./data:/data"
  playit:
    image: embeddedt/playit
    stop_grace_period: 1s
    networks:
      serverbridge:
        ipv4_address: 10.1.0.3
    volumes:
      - "./playit:/etc/playit"

networks:
  serverbridge:
    driver: bridge
    ipam:
      driver: default
      config:
        - subnet: 10.1.0.0/24
```

2. Start the Docker environment by running `docker compose up`.
3. Claim your playit agent using the link in the log.
4. Create a playit tunnel to IP 10.1.0.2, port 25565.
5. You should now be able to connect as normal.

## Known issues

* Minecraft clients currently seem to be unable to ping the server, even
though connecting works fine.
