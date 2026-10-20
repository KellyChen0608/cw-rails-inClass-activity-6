# Festival Schema Sprint: Starter Repo

A bare Rails app for the in-class exercise on foreign keys, associations, and nested routes (ESaaS Chapter 5). It has **no models, no migrations, and no routes** on purpose. You build all of that by hand.

## Quick start

```bash
bin/setup          # installs gems and prepares the SQLite database
git checkout -b pair-a-festivals   # use your own pair's branch name
```

Requires Ruby 3.1+ (Rails 7.1, SQLite).

## The rules

- **No `rails generate`.** `bin/rails generate` and `bin/rails destroy` are switched off in this repo. Write migration and model files in your editor.
- Use exactly these migration file names so tables are created in the right order:

  | Order | File |
  |---|---|
  | 1 | `db/migrate/20260101000100_create_festivals.rb` |
  | 2 | `db/migrate/20260101000200_create_stages.rb` |
  | 3 | `db/migrate/20260101000300_create_artists.rb` |
  | 4 | `db/migrate/20260101000400_create_tracks.rb` |
  | 5 | `db/migrate/20260101000500_create_attendees.rb` |
  | 6 | `db/migrate/20260101000600_create_tickets.rb` |
  | 7 | `db/migrate/20260101000700_create_performances.rb` |

- In `config/routes.rb`, edit **only your own section** to keep merge conflicts small.
- **Never hand-merge `db/schema.rb`.** After merging branches, delete it and run `bin/rails db:drop db:create db:migrate` to regenerate it.

## Useful commands

| Command | What it does |
|---|---|
| `bin/rails db:migrate` | Run pending migrations and update `db/schema.rb` |
| `bin/rails db:rollback` | Undo the last migration |
| `bin/rails db:migrate:status` | Show which migrations have run |
| `bin/rails console` | Try your models interactively |
| `bin/rails routes \| grep stages` | Show routes matching a word |
| `bin/rails festival:check` | Self-check: are the tables, foreign keys, associations, and routes in place? |
| `bin/rails db:seed` | Run `db/seeds.rb` |
| `bin/deliverables` | Collect your deliverables into `submission/` |

`festival:check` only confirms the pieces exist and are wired up. It cannot tell whether your choices make sense, and passing all checks is not a grade.

## Deliverables (one per team)

Run `bin/deliverables` on your merged branch after `db:migrate`. It collects:

1. `submission/schema.rb`
2. `submission/models.txt` (all models)
3. `submission/routes.txt` (the nested routes)
4. `submission/seeds.rb` (or add your own `submission/console_transcript.txt`)

Then fill in **`submission/reflection.md`** by hand and commit everything.

## Layout

```
app/models/            only application_record.rb to start
config/routes.rb       empty, with one marked section per pair
db/migrate/            empty
db/seeds.rb            empty, with instructions
lib/festival_check.rb  the self-check behind bin/rails festival:check
submission/            deliverables go here
```

---

## Instructor notes

**Before class**

1. Run `bin/setup` once on your machine, then commit the generated `Gemfile.lock` so every team gets the same gem versions.
2. If your students use a different Rails version, edit the `rails` line in the `Gemfile`, `config.load_defaults` in `config/application.rb`, and the `Migration[7.1]` version in the handout.
3. Push to GitHub (or your course platform) and have teams fork or clone it.

**Notes**

- The starter has no `schema.rb`; it appears after the first `db:migrate`. It is deliberately *not* gitignored.
- To re-enable generators for your own use: `ALLOW_GENERATE=1 bin/rails generate ...`
- The app is API-only (no views or assets), so the optional stub controllers need no templates.
- `festival:check` expects the resource names from the handout (`festivals`, `stages`, `artists`, `tracks`, `attendees`, `tickets`, `performances`) and the nesting listed there. If you change the domain, edit the tables and lists at the top of `lib/festival_check.rb`.
