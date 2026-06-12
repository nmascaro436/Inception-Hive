# User Documentation

## What Services Are Provided?

This stack runs a complete WordPress website with three services:

- **NGINX** — handles all incoming HTTPS traffic on port 443.
- **WordPress** — the website and blog platform.
- **MariaDB** — the database storing all content, users, and settings.

The website is accessible at:

```text
https://nmascaro.42.fr
```

---

## Starting and Stopping the Project

### Start

```bash
make
```

Builds and starts all containers. Use this the first time or after code changes.

```bash
make up
```

Starts already built containers without rebuilding. Faster for daily use.

### Stop

```bash
make down
```

Stops all containers but keeps images and data intact.

### Full Reset

```bash
make fclean
```

Stops containers, removes images, and deletes all data. Use before a fresh start.

---

## Accessing the Website

### Website

Open a browser and go to:

```text
https://nmascaro.42.fr
```

> **Note:** The browser will show a security warning because the SSL certificate is self-signed. Click **Advanced** and **Proceed** to continue.

### Admin Panel

```text
https://nmascaro.42.fr/wp-admin
```

Login with the administrator credentials stored in `srcs/.env`:

- **Username:** `wpmaster`
- **Password:** value of `WP_ADMIN_PASSWORD` in `.env`

---

## Credentials

All credentials are stored in two places:

| File | Contents |
|--------|----------|
| `srcs/.env` | WordPress users, database name, usernames |
| `secrets/db_password.txt` | Database user password |
| `secrets/db_root_password.txt` | Database root password |

These files are ignored by git and must never be committed to the repository.

---

## Checking That Services Are Running

```bash
docker ps
```

You should see three containers with **STATUS Up**:

- nginx
- wordpress
- mariadb

To check logs for a specific service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

## WordPress Users

| Username | Role | Description |
|-----------|------|-------------|
| wpmaster | Administrator | Full access to WordPress dashboard |
| nmascaro | Author | Can write posts, limited access |