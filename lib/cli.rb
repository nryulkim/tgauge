require 'rubygems'
require 'thor'
require 'active_support/inflector'
module TGauge
  #Generates models, controllers, and migrations. Alias 'g'
  class Generate < Thor
    desc 'model <name>', 'generate a model.'
    def model(name)
      File.open('./app/models/#{name.downcase}.rb', 'w') do |f|
        f.write("class #{name.capitalize} < TGauge::TRecordBase\n\n")
        f.write("end\n")
        f.write("#{name.capitalize}.finalize!")
      end

      migration("Create#{name.capitalize}}")
      puts "#{name} model created"
    end

    desc 'controller <name>', 'generate a controller.'
    def controller(name)
      File.open('./app/controllers/#{name.downcase}.rb', 'w') do |f|
        f.write("class #{name.capitalize}Controller < TGauge::TControllerBase\n\n")
        f.write("end")
      end

      Dir.mkdir "./app/views/#{name.downcase}_controller"
      puts "#{name} controller created"
    end

    desc 'migration <name>', 'generate an empty sql file.'
    def migration(name)
      #timestamp
      ts = Time.now.to_i
      filename = "#{ts}_#{name.underscore.downcase}"

      File.open('./db/migrations/#{filename}.sql', 'w') do |f|
        f.write "CREATE TABLE IF NOT EXISTS #{name} (\n"
        f.write "\tid SERIAL PRIMARY KEY,\n"
        f.write ')'
      end
    end
  end

  class Db < Thor
    desc 'create', 'creates the DB'
    def create
      require_relative '../lib/db_connection'
      TGauge::DBConnection.reset
      puts 'db created!'
    end

    desc 'migrate', 'runs pending migrations'
    def migrate
      # Creates Version table if necessary,
      # then runs needed migrations in order.
      require_relative '../lib/db_connection'
      TGauge::DBConnection.migrate
      puts 'migrated!'
    end

    desc 'seed', 'seeds the DB'
    def seed
      require_relative '../lib/puffs'
      TGauge::Seed.populate
      puts 'db seeded!'
    end

    desc 'reset', 'resets the DB and seeds it'
    def reset
      create
      migrate
      seed
      puts 'db reset!'
    end
  end

  #top level commands
  class CLI < Thor
    register(Generate, 'generate', 'generate <command>', 'Generates a model, migration, or controller.')
    register(Db, 'db', 'db <command>', 'Accesses commands for the DB.')

    desc 'g', 'shortcut for generate'
    subcommand 'g', Generate

    desc 'server', 'starts the WebBrick server'
    def server
      require_relative '../lib/tgauge.rb'
      TGauge::Server.start
    end

    desc 'new', 'creates a new TGauge app'
    def new(name)
      Dir.mkdir "./#{name}"
      Dir.mkdir "./#{name}/config"

      File.open("./#{name}/config/database.yml", 'w') do |f|
        f.write("database: #{name}")
      end

      Dir.mkdir "./#{name}/app"
      Dir.mkdir "./#{name}/app/models"
      Dir.mkdir "./#{name}/app/views"
      Dir.mkdir "./#{name}/app/controllers"
      File.open("./#{name}/app/controllers/application_controller.rb", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/template/app/controllers/application_controller.rb', __FILE__))
      end
      File.open("./#{name}/config/routes.rb", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/template/config/routes.rb', __FILE__))
      end
      Dir.mkdir "./#{name}/db"
      Dir.mkdir "./#{name}/db/migrations"
      File.open("./#{name}/db/seeds.rb", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/template/db/seeds.rb', __FILE__))
      end
      File.open("./#{name}/Gemfile", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/template/Gemfile', __FILE__))
      end
    end
  end
end
