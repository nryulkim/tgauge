require 'rack'
require_relative './config/routes'
require_relative 'lib/static_viewer'
require_relative 'lib/show_exceptions'

module TGauge
  class Server
    def self.start
      app = Proc.new do |env|
        req = Rack::Request.new(env)
        res = Rack::Response.new
        ROUTER.run(req, res)
        res.finish
      end

      full_app = Rack::Builder.new do
        use ShowExceptions
        use StaticViewer
        run app
      end.to_app

      Rack::Server.start({
        app: full_app,
        Port: 3000
      })
  end
end