# frozen_string_literal: true

def seed
  cargo_test_train = CargoTrain.new('cargo_test', '12345', 'tesla')
  @trains << cargo_test_train
  pass_test_train = PassTrain.new('pass_test', '54321', 'bosh')
  @trains << pass_test_train
  test_station_1 = Station.new('test_st_1')
  @stations << test_station_1
  test_station_2 = Station.new('test_station_2')
  @stations << test_station_2
  test_station_3 = Station.new('test_station_3')
  route_test = Route.new(test_station_1, test_station_2)
  @routes << route_test
end
