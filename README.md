# README

This app is a Rails 7 application using PostgreSQL, Hotwire, and js/css bundling. Below are the essentials for configuring environment variables via a `.env` file and setting up the development database.

## Environment Variables (.env)

- Loader: In development and test, `dotenv-rails` automatically loads variables from a `.env` file at the project root when you run Rails commands (server, console, tasks).
- Git ignore: `.env` files are ignored by Git (see `.gitignore`). Do not commit secrets.
- Location: Create a file named `.env` in the repository root.
- Database variables: `config/database.yml` reads these for development:
	- `DATABASE_HOST`
	- `DATABASE_USERNAME`
	- `DATABASE_PASSWORD`

Example `.env`:

```
# PostgreSQL connection for development
DATABASE_HOST=localhost
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password_here
```

