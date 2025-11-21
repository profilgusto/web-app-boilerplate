# SNCT Mapa – Next.js Boilerplate (Dockerized)

A clean Next.js + React TypeScript boilerplate, fully containerized for development and production.

## Features
- Next.js 14 (App Router) + React 18
- TypeScript strict mode
- Vitest + Testing Library
- One Dockerfile (multi-stage) and two compose files:
  - `docker-compose.dev.yml` for dev with hot reload
  - `docker-compose.prod.yml` for production
- Tailwind CSS (via PostCSS) preconfigured

## Quick Start

### Development (hot reload)
Run the app in dev mode inside Docker; local files are mounted and changes hot-reload.

```sh
docker compose -f docker-compose.dev.yml up --build
```

Then open http://localhost:3000.

### Production
Build and run the optimized production image using the standalone output.

```sh
docker compose -f docker-compose.prod.yml up --build
```

### Run tests (inside container)
In another shell, exec into the dev container and run tests:

```sh
docker compose -f docker-compose.dev.yml exec web npm test
```

Or run in watch mode:

```sh
docker compose -f docker-compose.dev.yml exec web npm run test:watch
```

## Notes
- node_modules are installed inside the container to avoid host/OS differences. In dev, we mount a named volume at `/app/node_modules` so they persist across restarts.
- The production image uses Next.js `standalone` output for a small runtime image.
 - After adding dependencies (e.g., Tailwind), restart the dev container so it runs `npm install` inside the container: `docker compose -f docker-compose.dev.yml down && docker compose -f docker-compose.dev.yml up --build`.

## Tailwind CSS
- Global directives live in `app/globals.css`.
- Tailwind config is in `tailwind.config.ts` and PostCSS config in `postcss.config.js`.
- Example usage: see `app/page.tsx` for basic utility classes.

## Scripts
- `npm run dev` – Start Next.js dev server on 0.0.0.0:3000
- `npm run build` – Build the app
- `npm run start` – Start the production server
- `npm test` – Run tests once with Vitest
- `npm run test:watch` – Run tests in watch mode
- `npm run typecheck` – TypeScript type checking

---

Happy hacking!