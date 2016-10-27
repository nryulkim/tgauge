# TGauge

TGauge is a lightweight Ruby MVC / ORM gem.

## Installation

1. `gem install tgauge`

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

## Functionality
### Controllers
- session
  - Controllers have access to the session cookie
- flash
  - Controllers have access to a flash object that persists the data for only one call.
- CSRF Protection
  - Each controller authenticates for CSRF attacks. This can be disabled by setting the check_authenticity_token variable to false.

### Routes
- Add the controller's routes through the `config/routes.rb`
  - The format should be as follows.
    - `get Regexp.new("^/MODEL/$"), CONTROLLER, :index`
  - You can use `get`, `post`, `put`, and `delete` routes.

### ORM
- Available functions
  - attr_reader
    - Creates a function that gives lets you fetch the data from an instance variable
```
Usage:

attr_reader :name1, :name2
```

```
def [name]
  @name
end
```
  - attr_accessor
    - Uses attr_reader to create a fetch function for an instance variable.
    - Creates a function that gives lets you set the data from an instance variable.
```
Usage:

attr_accessor :name1, :name2
```

```
def [name]= (val)
  @name = val
end
```
  - destroy_all
    - Destroys each item in the associated table.
```
Usage:

Model.destroy_all
```

  - find
    - Find's a specific item in the associated table with the id of the input.
```
Usage:

Model.find(id#)
```
  - all
    - Gets all items in the associated table.
```
Usage:

Model.all
```
  - new
    - Creates a new instance of the Model.
```
Usage:

Model.new(options_hash)
```
  - save
    - Saves the instance of the Model into the table.
```
Usage:

Model.new(options_hash).save
```
  - create
    - Creates a new instance of Model and then saves it.
```
Usage:

Model.create(options_hash)
```
  - where
    - Finds items with the condition provided.
```
Usage:

Model.where(attr: val)
```

- Models are able to associate with other models.
  - Models can have a belongs_to association with another model.
  - Models can have a have_many or has_one association with another model.
  - Models can have a through relationship to another model.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nryulkim/TGauge.
