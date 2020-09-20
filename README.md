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

## Create Deploy key

```sh
ssh puma-nginx cat .ssh/authorized_keys

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_API_TOKEN" \
  https://api.github.com/repos/shgtkshruch/puma-nginx-systemd-itamae-recipe/keys \
  -d '{ "title": "EC2_PUB_KEY", "key": "XXX", "read_only": "true" }'
```

ref: https://docs.github.com/en/rest/reference/repos#create-a-deploy-key
