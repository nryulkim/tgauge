require 'rubygems'
require 'thor'
require 'active_support/inflector'
module TGauge
  #Generates models, controllers, and migrations. Alias 'g'
  class Generate < Thor
    desc 'model <name>', 'generate a model.'
    def model(name)
      File.open("./app/models/#{name.downcase}.rb", 'w') do |f|
        f.write("class #{name.capitalize} < TGauge::TRecordBase\n\n")
        f.write("end\n")
        f.write("#{name.capitalize}.finalize!")
      end

      migration("#{name.capitalize}")
      puts "#{name} model created"
    end

    desc 'controller <name>', 'generate a controller.'
    def controller(name)
      File.open("./app/controllers/#{name.downcase}_controller.rb", 'w') do |f|
        f.write("class #{name.capitalize}Controller < TGauge::TControllerBase\n\n")
        f.write("end")
      end

      Dir.mkdir "./app/views/#{name.downcase}"
      puts "#{name} controller created"
    end

    desc 'migration <name>', 'generate an empty sql file.'
    def migration(name)
      #timestamp
      ts = Time.now.to_i
      filename = "#{ts}_#{name.underscore.downcase}"

      File.open("./db/migrations/#{filename}.sql", 'w') do |f|
        f.write "CREATE TABLE IF NOT EXISTS #{name} (\n"
        f.write "\tid SERIAL PRIMARY KEY,\n"
        f.write ')'
      end
    end

    desc 'container <name>, <path>', 'generates a component with name and its container'
    def container(name, path = "")
      component_name = name.split('_').collect(&:capitalize).join
      component_filename = name.underscore.downcase

      File.open("./frontend/components/#{path}#{component_filename}_container.js", "w") do |f|
        f.write "import { connect } from 'react-redux';\n"
        f.write "import #{component_name} from './component_filename'\n"
        f.write "\n"
        f.write "const mapStateToProps = (state) => {\n"
        f.write "  return ({\n"
        f.write "\n"
        f.write "  });\n"
        f.write "};\n"
        f.write "\n"
        f.write "const mapDispatchToProps = (dispatch) => {\n"
        f.write "  return ({\n"
        f.write "\n"
        f.write "  });\n"
        f.write "};\n"
        f.write "\n"
        f.write "export default connect(\n"
        f.write "  mapStateToProps, mapDispatchToProps\n"
        f.write ")(#{component_name});"
      end

      self.component(name, path = "")
    end

    desc 'component <name>, <path>', 'generates a component with name'
    def component(name, path)
      component_name = name.split('_').collect(&:capitalize).join
      component_filename = name.underscore.downcase

      File.open("./frontend/components/#{path}#{component_filename}.jsx", "w") do |f|
        f.write "import React from 'react';\n\n"
        f.write "class #{component_name} extends React.Component {\n"
        f.write "  constructor(props){\n"
        f.write "    super(props);\n"
        f.write "  }\n"
        f.write "\n"
        f.write "  render(){\n"
        f.write "    return(\n"
        f.write "      <html/>\n"
        f.write "    );\n"
        f.write "  }\n"
        f.write "}\n"
        f.write "export default #{component_name}"
      end
    end
  end

  class Db < Thor
    desc 'create', 'creates the DB'
    def create
      require_relative '../lib/db/db_connection'
      TGauge::DBConnection.reset
      puts 'db created!'
    end

    desc 'migrate', 'runs pending migrations'
    def migrate
      # runs needed migrations in order.
      require_relative '../lib/db/db_connection'
      TGauge::DBConnection.migrate
      puts 'migrated!'
    end

    desc 'seed', 'seeds the DB'
    def seed
      # runs the seeds file in db/seeds that has been created by the new command
      require_relative '../lib/tgauge'
      TGauge::Seed.populate
      puts 'db seeded!'
    end

    desc 'reset', 'resets the DB and seeds it'
    def reset
      #  the PostgreSQL database
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

    desc 'new <name> <React?(true/false)>', 'creates a new TGauge app with or without React folder directories ()'
    def new(name, react = false)
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
        f.write File.read(File.expand_path('../../lib/templates/app/controllers/application_controller.rb', __FILE__))
      end
      File.open("./#{name}/config/routes.rb", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/templates/config/routes.rb', __FILE__))
      end
      Dir.mkdir "./#{name}/db"
      Dir.mkdir "./#{name}/db/migrations"
      File.open("./#{name}/db/seeds.rb", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/templates/db/seeds.rb', __FILE__))
      end
      File.open("./#{name}/Gemfile", 'w') do |f|
        f.write File.read(File.expand_path('../../lib/templates/Gemfile', __FILE__))
      end
      if react
        Dir.mkdir "./#{name}/frontend"
        Dir.mkdir "./#{name}/frontend/actions"
        Dir.mkdir "./#{name}/frontend/components"
        Dir.mkdir "./#{name}/frontend/reducer"
        File.open("./#{name}/frontend/reducer/root_reducer.js", 'w') do |f|
          f.write File.read(File.expand_path('../../lib/templates/frontend/reducer/root_reducer.js', __FILE__))
        end
        Dir.mkdir "./#{name}/frontend/middleware"
        File.open("./#{name}/frontend/middleware/root_middleware.js", 'w') do |f|
          f.write File.read(File.expand_path('../../lib/templates/frontend/middleware/root_middleware.js', __FILE__))
        end
        Dir.mkdir "./#{name}/frontend/store"
        File.open("./#{name}/frontend/store/store.js", 'w') do |f|
          f.write File.read(File.expand_path('../../lib/templates/frontend/store/store.js', __FILE__))
        end
        Dir.mkdir "./#{name}/frontend/utils"
      end
    end
  end
end
