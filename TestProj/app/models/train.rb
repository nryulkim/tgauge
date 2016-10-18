class Train < TGauge::TRecordBase
  def index
    @trains = Train.all

    render_content(JSON.generate(@users), "application.json")
  end
end
Train.finalize!
