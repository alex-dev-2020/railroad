# frozen_string_literal: true

module Seed
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
    def seed
      cargo_test_train = CargoTrain.new('123-45', 'tesla')
      cargo_test_wagon = CargoWagon.new(100)
      cargo_test_train.add_wagon(cargo_test_wagon)
      @trains << cargo_test_train
      pass_test_train = PassTrain.new('543-21', 'bosh')
      pass_test_wagon = PassWagon.new(45)
      pass_test_train.add_wagon(pass_test_wagon)
      @trains << pass_test_train
      test_station_1 = Station.new('test-station-1')
      @stations << test_station_1
      test_station_2 = Station.new('test-station-2')
      @stations << test_station_2
      test_station_3 = Station.new('test-station-3')
      @stations << test_station_3
      route_test = Route.new(test_station_1, test_station_2)
      @routes << route_test
      puts
      print_stations_only
      print_routes
      print_route_stations(routes[0])
      print_trains
    end
  end
end
