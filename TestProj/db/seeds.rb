module TGauge
  class Seed
    def self.populate
      #PUT IN SEEDS HERE
      Train.destroy_all

      Train.new({sound: "choo choo"}).save
    end
  end
end
