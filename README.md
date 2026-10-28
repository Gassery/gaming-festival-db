# Gaming Festival Database

[![ci](https://github.com/Gassery/gaming-festival-db/actions/workflows/ci.yml/badge.svg)](https://github.com/Gassery/gaming-festival-db/actions/workflows/ci.yml)

A PostgreSQL schema for a tabletop-and-video gaming festival: exhibitors and their booths, the roles they hold, the product categories they list, and the stage sessions they run. Independent project modelled on the public PAX Aus exhibitor conventions.

Six tables, one view, integrity rules expressed as constraints, sample data, runnable queries, and assertions that run on every push.

## Data model

| Table | Purpose |
| --- | --- |
| `exhibitors` | One row per exhibitor, unique booth label |
| `types` | Role vocabulary (Exhibitor, Expo Hall, PAX Rising, Tabletop) |
| `exhibitor_types` | Many-to-many between exhibitors and roles |
| `categories` | Genre and product vocabulary |
| `product_categories` | Many-to-many between exhibitors and categories |
| `activities` | Stage and tabletop sessions, with date and time windows |

`activity_pairs` is a view over `activities` that returns each unordered pair of sessions sharing a room.

See [`docs/erd.mmd`](docs/erd.mmd) for the ER diagram (rendered by GitHub).

## Design decisions

**Surrogate key on `activities`.** There is no natural key: two exhibitors can run identically titled sessions at the same time, so `(title, start_date, start_time)` is not unique. An identity column keeps the primary key stable and lets the view use `activity_id` ordering to deduplicate pairs.

**Booth labels as a check constraint.** Venue booths are printed on the floor plan as uppercase letters and digits (`TT1742`, `4420`). Enforcing `^[A-Z0-9]+$` catches typos such as `tt-1742` at insert time instead of at the printer.

**Mixed foreign-key actions.** Deleting an exhibitor cascades to its roles, categories and sessions, because those rows have no meaning without it. Deleting a category is restricted: categories are shared vocabulary, and silently removing one would corrupt every exhibitor that relies on it.

**Time checks.** Every session must fall inside the festival window (9–11 October 2026), and must end after it starts, or end later on the same day.

## Run it

Docker is the only prerequisite; a local `psql` is optional.

### Any platform (bash/zsh)

```bash
docker compose up -d
psql -h localhost -U postgres -d festival -v ON_ERROR_STOP=1 -f schema.sql -f seed.sql

for f in queries/*.sql; do
  psql -h localhost -U postgres -d festival -v ON_ERROR_STOP=1 -f "$f"
done

psql -h localhost -U postgres -d festival -v ON_ERROR_STOP=1 -f tests/assert.sql
```

### Windows (PowerShell)

PowerShell has no `<` input redirection and no `for f in ...` loop, so pipe each file into the container's `psql`. Docker Desktop with the WSL2 backend is enough; no local PostgreSQL install is needed.

```powershell
docker compose up -d

Get-ChildItem queries/*.sql | ForEach-Object {
    Get-Content $_ | docker compose exec -T db psql -U postgres -d festival -v ON_ERROR_STOP=1 -f -
}

Get-Content tests/assert.sql | docker compose exec -T db psql -U postgres -d festival -v ON_ERROR_STOP=1 -f -
```

The first `docker compose up` already applies `schema.sql` and `seed.sql` through the container's init directory. After editing the schema, recreate the volume first:

```powershell
docker compose down -v
docker compose up -d
```

If you prefer a native client, install it with `winget install PostgreSQL.PostgreSQL.16`; the `psql` commands in the bash section then work unchanged in PowerShell.

## Queries

| File | Demonstrates |
| --- | --- |
| `queries/01_exhibitors.sql` | Single-table select and ordering |
| `queries/02_natural_join.sql` | `NATURAL JOIN` across a junction table |
| `queries/03_group_by_having.sql` | `GROUP BY` with `HAVING` |
| `queries/04_subquery.sql` | `IN` subquery |
| `queries/05_self_join_view.sql` | Self-join wrapped in a view |

## Tests

`tests/assert.sql` checks row counts, the view output, and that each constraint actually fires — a lowercase booth, a category delete in use, and an out-of-window session must all be rejected. CI runs schema, seed, queries and assertions against a real PostgreSQL 16 service on every push.

## License

MIT
