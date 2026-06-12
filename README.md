*This project has been created as part of the 42 curriculum by [nmascaro].*

# Inception

## Description

Inception is a system administration project from the 42/Hive curriculum. The goal is to set up a small but complete web infrastructure using Docker, running entirely inside a Virtual Machine.

The infrastructure consists of three Docker containers working together:

- **NGINX** — the only entry point, handles HTTPS (TLS 1.2/1.3) and forwards requests.
- **WordPress + PHP-FPM** — the web application layer.
- **MariaDB** — the database storing all WordPress data.

All containers are built from scratch using custom Dockerfiles based on Alpine Linux 3.20. No pre-made application images are used.

---

## Design Choices

### Virtual Machines vs Docker

A Virtual Machine emulates an entire computer including its own OS kernel, hardware, and resources. It is heavy and slow to start. Docker containers share the host OS kernel and are isolated at the process level — they are lightweight, start in seconds, and use far fewer resources. However, VMs provide stronger isolation. In this project, Docker runs inside a VM to combine both approaches.

### Secrets vs Environment Variables

Environment variables (.env) store non-sensitive configuration like domain names and usernames. They are passed to containers at runtime and are convenient but visible in the environment. Docker secrets store sensitive data like passwords in files, which are mounted into containers securely. Secrets are harder to accidentally expose than environment variables. In this project, passwords are stored in the `secrets/` folder and ignored by git.

### Docker Network vs Host Network

With `network: host`, a container shares the host's network stack directly — it can see all host ports and there is no isolation. With a Docker bridge network (used here), containers get their own isolated network. They can communicate with each other by container name, but are isolated from the host. This is more secure and is required by the project rules.

### Docker Volumes vs Bind Mounts

Both persist data outside containers. Bind mounts link a specific host path directly to the container. Docker volumes are managed by Docker and stored in Docker's data directory. In this project we use bind mounts pointing to `/home/nmascaro/data/` so the data location is explicit and easy to find, as required by the project.

---

## Use of Docker

Docker is used to run each service in its own isolated container. Each container is defined by a custom Dockerfile. Docker Compose orchestrates all three containers, their networks, and volumes with a single command. The Makefile wraps Docker Compose commands for convenience.

---

## Instructions

### Prerequisites

- A Virtual Machine running Alpine Linux 3.20
- Docker and Docker Compose installed
- The domain `nmascaro.42.fr` pointing to the VM's IP

### Setup

Clone the repository inside the VM:

```bash
git clone git@github.com:nmascaro436/Inception-Hive.git
cd Inception-Hive
```

The `.env` file and the files inside `secrets/` are excluded from the repository through `.gitignore` because they contain credentials. After cloning the project, they must be created manually.

Create the secrets files:

```bash
echo "yourpassword" > secrets/db_password.txt
echo "yourrootpassword" > secrets/db_root_password.txt
```

Create the `.env` file in `srcs/`:

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

### Running the Project

```bash
make        # Build images and start all containers
make up     # Start already built containers
make down   # Stop all containers
make re     # Full rebuild from scratch
make fclean # Remove all containers, images, and data
```

### Accessing the Site

- **Website:** `https://nmascaro.42.fr`
- **Admin panel:** `https://nmascaro.42.fr/wp-admin`

---

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [WordPress CLI Documentation](https://developer.wordpress.org/cli/commands/)
- [Alpine Linux Packages](https://pkgs.alpinelinux.org/)
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [TLS/SSL Best Practices](https://configurator.tlsref.org/)

---

## AI Usage

Claude was used throughout this project as a learning and debugging assistant. Specifically:

- Explaining Docker concepts (images, containers, volumes, networks, PID 1)
- Writing and debugging Dockerfiles and shell scripts
- Troubleshooting container startup errors (MariaDB networking, PHP-FPM configuration)
- Setting up the VM network (host-only adapter, port forwarding)
- Writing this documentation