Itamae recipe for configuring [Puma](https://puma.io/) and [Nginx](https://www.nginx.com/) with [systemd](https://www.freedesktop.org/wiki/Software/systemd/).

## Requirements
- [Docker Compose](https://docs.docker.com/compose/)
- [dip](https://github.com/bibendi/dip)
- [itamae](https://itamae.kitchen/)

## Build Docker image

```sh
COMPOSE_DOCKER_CLI_BUILD=1 docker-compose build
```

## Build infra

```sh
dip terraform init
dip terraform plan
dip terraform apply
```

## Provision

```sh
itamae ssh -h puma-nginx -y itamae/nodes/centos.yml itamae/cookbooks/rails/default.rb 
```
