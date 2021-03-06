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

    def self.reset
      self.instance
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
      open if @postgres.nil?

      @postgres
    end

    def self.execute(*args)
      args.flatten!

      print_query(*args)
      query = self.number_placeholders(args.unshift[0])
      params = args[1..-1]
      params.flatten!
      instance.exec(query, params)
    end

    private

    def self.number_placeholders(query_string)
      count = 0
      query_string.chars.map do |char|
        if char == "?"
          count += 1
          "$#{count}"
        else
          char
        end
      end.join("")
    end

    def self.ensure_migrations_table
      table = instance.exec(<<-SQL)
        SELECT to_regclass('migrations') AS exists
      SQL

      unless table[0]['exists']
        instance.exec(<<-SQL)
          CREATE TABLE migrations(
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
