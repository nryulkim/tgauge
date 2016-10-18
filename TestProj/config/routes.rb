ROUTER = TGauge::Router.new

ROUTER.draw do
  #ADD ROUTES HERE
  #EXAMPLE:
  #get Regexp.new("^/MODEL/"), CONTROLLER, :index

  get Regexp.new("^/$"), TrainsController, :index
end
