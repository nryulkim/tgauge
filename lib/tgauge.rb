module TGauge
end

require_relative './version.rb'

require_relative './app/models/trecord_base'
require_relative './app/controllers/tcontroller_base'

Dir.glob('./app/models/*.rb') { |file| require file }
Dir.glob('./app/controllers/*.rb') { |file| require file }

require './db/seeds'

require_relative './db/db_connection'
require_relative './db/router'
require_relative './db/server'

require_relative './cli'
