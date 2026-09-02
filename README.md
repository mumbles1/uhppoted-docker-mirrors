# Turnage Automation UHPPOTED Docker mirrors

Temporary, unofficial, source-built Docker images for the UHPPOTED projects while the upstream container registry migration is incomplete.

The images are built directly from the public upstream Codeberg repositories. No UHPPOTED source code is modified or vendored in this repository.

## Images

| Component | Temporary image | Upstream source |
| --- | --- | --- |
| Controller simulator | `ghcr.io/mumbles1/uhppoted-simulator:latest` | `https://codeberg.org/uhppoted/uhppoted-simulator` |
| REST API | `ghcr.io/mumbles1/uhppoted-rest:latest` | `https://codeberg.org/uhppoted/uhppoted-rest` |
| MQTT endpoint | `ghcr.io/mumbles1/uhppoted-mqtt:latest` | `https://codeberg.org/uhppoted/uhppoted-mqtt` |
| Administrative web UI | `ghcr.io/mumbles1/uhppoted-httpd:latest` | `https://codeberg.org/uhppoted/uhppoted-httpd` |

Each image is built for:

- `linux/amd64`
- `linux/arm64`
- `linux/arm/v7`

The workflow also publishes a commit-specific `sha-...` tag. When the upstream repository exposes a version tag, that version is published as an additional image tag.

## Publish or refresh the mirrors

Open **Actions → Build UHPPOTED mirrors → Run workflow**. The scheduled workflow checks upstream weekly as a convenience, but a manual build is recommended when you need a known update.

After the first successful build, run `make-packages-public.ps1` once from an authenticated PowerShell terminal. GitHub container packages may initially be private even when this repository is public.

## Simulator example

```yaml
services:
  simulator:
    image: ghcr.io/mumbles1/uhppoted-simulator:latest
    container_name: uhppoted-simulator
    restart: unless-stopped
    ports:
      - "8000:8000/tcp"
      - "60000:60000/udp"
    volumes:
      - /DATA/AppData/uhppoted-simulator:/usr/local/etc/uhppoted
```

The simulator management endpoint is:

```text
http://SERVER-IP:8000/uhppote/simulator
```

It is an API endpoint, not a graphical web page.

## Important notice

These packages are not official UHPPOTED releases and are not affiliated with or endorsed by the upstream project. The original licenses and copyrights remain with the upstream authors. Replace these temporary images with the official packages when the upstream registry is consistently available.

