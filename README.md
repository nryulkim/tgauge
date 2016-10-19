# TGauge

TGauge is a lightweight Ruby MVC / ORM gem.

## Installation

1. `install gem tgauge`

## Usage

### New Project
- `tgauge new [PROJ NAME]`
  - Creates a new project directory with [PROJ NAME] as the name
- `tgauge server`
  - Runs the server

### Generate (g)
- `tgauge g migration [name]`
  - Creates an empty SQL file in `db/migrations/` with a timestamp.
- `tgauge g controller [name]`
  - Creates a controller file with a directory in views.
- `tgauge g model [name]`
  - Creates a model file and a migration file.

### Database (db)
- `tgauge db create`
  - Sets up the database
- `tgauge db seed`
  - Seeds the database from `db/seeds`
- `tgauge db migrate`
  - Runs any migrations in `db/migrations/`
- `tgauge db reset`
  - Creates / migrates / seeds the database


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nryulkim/TGauge.
