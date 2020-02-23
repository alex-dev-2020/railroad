require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'


class Railroad
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end


# метод для генерации тестовых объектов
  def seed
    cargo_test_train = CargoTrain.new('cargo_test')
    @trains << cargo_test_train
    pass_tesr_train = PassTrain.new('pass_test')
    @trains << pass_tesr_train
    test_station_1 = Station.new('test_st_1')
    @stations << test_station_1
    test_station_2 = Station.new('test_station_2')
    @stations << test_station_2
    test_station_3 = Station.new('test_station_3')
    route_test = Route.new(test_station_1, test_station_2)
    @routes << route_test
  end
end