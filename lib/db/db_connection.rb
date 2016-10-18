require 'pg'
require 'uri'
require 'yaml'

PRINT_QUERIES = ENV['PRINT_QUERIES'] == 'true'
MIGRATION_FILES = Dir.glob("./db/migrations/*.sql").to_a

module TGauge
  class DBConnection
    def self.app_name
      YAML.load_file(Dir.pwd + '/config/database.yml')['database']
    end

    def self.open
      @postgres = PG::Connection.new(
        dbname: app_name,
        port: 5432
      )
    end

    def self.migrate
      ensure_migrations_table

      MIGRATION_FILES.each do |file|
        filename = file.match(/([\w|-]*)\.sql$/)[1]

        unless migrated_files.include?(filename)
          instance.exec(File.read(file))
          instance.exec(<<-SQL)
            INSERT INTO
            migrations (filename)
            VALUES
            ('#{filename}')
          SQL
        end
      end
    end

    def self.instance
      open if @db.nil?

      @db
    end

    def self.execute(*args)
      print_query(*args)
      instance.execute(*args)
    end

    def self.last_insert_row_id
      instance.last_insert_row_id
    end

    def self.reset
      commands = [
        "dropdb #{app_name}",
        "createdb #{app_name}"
      ]
      commands.each { |command| `#{command}` }
    end

    private

    def self.ensure_migrations_table
      table = instance.exec(<<-SQL)
      SELECT to_regclass('migrations') AS exists
      SQL

      unless table[0]['exists']
        instance.exec(<<-SQL)
        CREATE_TABLE migrations(
        id SERIAL PRIMARY KEY,
        filename VARCHAR(255) NOT NULL
        )
        SQL
      end
    end

    def self.migrated_files
      Set.new instance.exec(<<-SQL).values.flatten
      SELECT
      filename
      FROM
      migrations
      SQL
    end

    def self.print_query(query, *interpolation_args)
      return unless PRINT_QUERIES

      puts '--------------------'
      puts query
      unless interpolation_args.empty?
        puts "interpolate: #{interpolation_args.inspect}"
      end
      puts '--------------------'
    end
  end
end
