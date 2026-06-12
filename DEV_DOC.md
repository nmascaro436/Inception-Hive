# Developer Documentation

## Setting Up the Environment From Scratch

### Prerequisites

- VirtualBox with an Alpine Linux 3.20 VM
- Docker and Docker Compose installed in the VM
- Git installed in the VM

### Installation

```bash
apk add docker docker-cli-compose git make
rc-service docker start
rc-update add docker default
```

### Clone the Repository

```bash
git clone git@github.com:nmascaro436/Inception-Hive.git
cd Inception-Hive
```

---

## Configuration Files

The `.env` file and the files inside `secrets/` are excluded from the repository through `.gitignore` because they contain credentials. After cloning the project, they must be created manually.

### `srcs/.env`

Create this file with the following variables:

```env
DOMAIN_NAME=nmascaro.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=yourpassword
MYSQL_ROOT_PASSWORD=yourrootpassword
WP_ADMIN_USER=wpmaster
WP_ADMIN_PASSWORD=yourpassword
WP_ADMIN_EMAIL=wpmaster@nmascaro.42.fr
WP_USER=nmascaro
WP_USER_PASSWORD=yourpassword
WP_USER_EMAIL=nmascaro@nmascaro.42.fr
```

### `secrets/db_password.txt`

```bash
echo "yourpassword" > secrets/db_password.txt
```

### `secrets/db_root_password.txt`

```bash
echo "yourrootpassword" > secrets/db_root_password.txt
```

---

## Domain Configuration

For browser access from the host machine, use a Chrome alias:

```bash
alias chrome='flatpak run com.google.Chrome --host-resolver-rules="MAP nmascaro.42.fr 192.168.56.101" --user-data-dir=/tmp/eval_profile'
```

---

## Building and Launching With Makefile

| Command | Description |
|----------|------------|
| `make` | Build images and start all containers |
| `make up` | Start already built containers |
| `make down` | Stop all containers |
| `make clean` | Stop containers and remove images |
| `make fclean` | Full cleanup including data |
| `make re` | Full rebuild from scratch |

---

## Managing Containers and Volumes

### View Running Containers

```bash
docker ps
```

### View Container Logs

```bash
docker logs <container_name>
docker logs -f <container_name>
```

### Execute Commands Inside a Container

```bash
docker exec -it wordpress sh
docker exec -it mariadb sh
docker exec -it nginx sh
```

### Manage WordPress via WP-CLI

```bash
docker exec wordpress wp user list --path=/var/www/html --allow-root
docker exec wordpress wp post list --path=/var/www/html --allow-root
```

### Manage MariaDB

```bash
docker exec -it mariadb mariadb -u root -p
```

---

## Project Data Storage

All persistent data is stored in `/home/nmascaro/data/` on the host VM:

| Path | Contents |
|--------|----------|
| `/home/nmascaro/data/db` | MariaDB database files |
| `/home/nmascaro/data/wp` | WordPress website files |

These folders are mounted as bind mount volumes in `docker-compose.yml`. Data persists even when containers are stopped or removed. Only `make fclean` deletes this data.

---

## Project Structure

```text
Inception-Hive/
├── Makefile
├── secrets/
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/nginx.conf
        │   └── tools/setup.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/www.conf
        │   └── tools/setup.sh
        └── mariadb/
            ├── Dockerfile
            ├── conf/my.cnf
            └── tools/setup.sh
```