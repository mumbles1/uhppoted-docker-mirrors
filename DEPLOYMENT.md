# Docker Compose integration

This stack provides two mutually exclusive profiles:

- `simulator`: starts the UHPPOTE controller simulator and REST API together.
- `physical`: starts the REST API with Linux host networking for UDP controller discovery on the physical LAN.

Do not start both profiles at once because both REST services listen on TCP port 8080.

## Simulator

```sh
docker compose -f docker-compose.integration.yml --profile simulator pull
docker compose -f docker-compose.integration.yml --profile simulator up -d
```

Verify the simulator and REST API:

```sh
curl http://127.0.0.1:8000/uhppote/simulator
curl http://127.0.0.1:8080/uhppote/device
```

The bundled sample controller has serial number `405419896`. Open door 1 through the operational REST API:

```sh
curl -X POST http://127.0.0.1:8080/uhppote/device/405419896/door/1 \
  -H "Content-Type: application/json" \
  -d '{}'
```

Generate a simulated card swipe:

```sh
curl -X POST http://127.0.0.1:8000/uhppote/simulator/405419896/swipe \
  -H "Content-Type: application/json" \
  -d '{"door":1,"card-number":10058400,"direction":1,"PIN":1357}'
```

Stop the simulator stack without deleting controller data:

```sh
docker compose -f docker-compose.integration.yml --profile simulator down
```

## Physical controller

The physical profile requires a Linux Docker host. It uses host networking so UDP broadcast discovery can reach controllers on the LAN.

Edit `config/uhppoted-physical.conf` to add the controller serial number and fixed IPv4 address for reliable production operation, then run:

```sh
docker compose -f docker-compose.integration.yml --profile physical pull
docker compose -f docker-compose.integration.yml --profile physical up -d
curl http://127.0.0.1:8080/uhppote/device
```

The host firewall must allow outbound and return UDP traffic on port 60000. The REST API is plain HTTP on port 8080 and should remain on a trusted network or be placed behind an authenticated TLS reverse proxy.