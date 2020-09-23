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

Save SSH private key to your machine.

## Provision

```sh
export RAILS_MASTER_KEY=(cat config/master.key)

# All
itamae ssh -h puma-nginx -y itamae/nodes/centos.yml itamae/bootstrap.rb

# Nginx
itamae ssh -h puma-nginx -y itamae/nodes/centos.yml itamae/cookbooks/nginx/default.rb

# Rails
itamae ssh -h puma-nginx -y itamae/nodes/centos.yml itamae/cookbooks/rails/default.rb
```

## Create Deploy key

```sh
export EC2_PUB_KEY=(ssh puma-nginx cat .ssh/authorized_keys)
export GITHUB_API_TOKEN=xxx

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "Authorization: token $GITHUB_API_TOKEN" \
  https://api.github.com/repos/shgtkshruch/puma-nginx-systemd-itamae-recipe/keys \
  -d '{ "title": "EC2_PUB_KEY", "key": " '"$EC2_PUB_KEY"' ", "read_only": "true" }'
```

ref: https://docs.github.com/en/rest/reference/repos#create-a-deploy-key

## Deploy Rails

```rb
dip bash

eval `ssh-agent`
ssh-add puma-nginx-systemd.pem

cap production puma:nginx_config
cap production deploy

# optional
cap production puma:restart
```

## SELinux

1. raise SELinux error
2. generate policy file

```sh
$ sudo grep nginx /var/log/audit/audit.log | audit2allow -m nginx
$ sudo checkmodule -M -m -o nginx.mod nginx.te
$ sudo semodule_package -o nginx.pp -m nginx.mod
```

3. apply policy

```sh
$ sudo semodule -i nginx.pp
```

ref: https://nts.strzibny.name/allowing-nginx-to-use-a-pumaunicorn-unix-socket-with-selinux/
