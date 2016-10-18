class TrainsController < TGauge::TControllerBase
  def index
    @trains = Train.all

    render_content(@trains, "application.json")
  end
end
