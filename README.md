
## Docker setup

This project is configured to run with Docker using PHP-FPM, Nginx, MySQL, Redis, and phpMyAdmin.

### Run locally with Docker

1. Open a terminal in the project root.
2. Start containers:
   ```bash
   docker compose up --build -d
   ```
3. Generate the application key and run migrations:
   ```bash
   docker compose exec app php artisan migrate --force
   ```
4. Run project-specific artisan commands from the app container, for example:
   ```bash
   docker compose exec app php artisan telegram:compare-posts
   ```
5. If you need to regenerate the key:
   ```bash
   docker compose exec app php artisan key:generate --force
   ```
6. Open the app in your browser:
    - App: `http://localhost:8080`
    - phpMyAdmin: `http://localhost:8081`

### Docker service notes

- `app` runs PHP 8.2 FPM
- `nginx` serves `public/`
- `mysql` stores the database
- `redis` runs Redis
- `phpmyadmin` provides database UI
- `node` builds frontend assets with `npm run build`
- Telegram session files are stored in `storage/telegram_auth_session.madeline` inside the Docker storage volume

### Database credentials

- Host: `mysql`
- Port: `3306`
- Database: `laravel`
- User: `laravel`
- Password: `secret`
- phpMyAdmin: `http://localhost:8081`
- phpMyAdmin login: `root` / `rootpassword`

> Important: do not run `php artisan` directly from your Windows host shell while `DB_HOST=mysql` is set. That host name only resolves inside Docker. Use `docker compose exec app php artisan ...` for all Laravel commands that use the database.

```bash
docker compose exec app bash
```

### Shut down

```bash
docker compose down -v
```

### Remote database with docker
```bash
docker compose exec app sh -c 'export DB_CONNECTION=mysql_remote && php artisan telegram:compare-posts 2026-06-05'
```

