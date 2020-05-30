require_relative 'train'
require_relative 'station'
require_relative 'made_by'
require_relative 'instance_counter'
require_relative 'valid'

puts 'Test for valid module'
puts Train.instances
test_valid_train = Train.new('test_train_valid', '222-33', 'bosh')
puts test_valid_train.number

puts Train.instances
test_invalid_train = Train.new('test_invalid_train', '032-84', 'siemens')
puts test_invalid_train

puts 'количество инстансов класса Station'
puts Station.instances
test_station_1 = Station.new('Test-station-1')
puts test_station_1.name
puts 'количество инстансов класса Station'
puts Station.instances
test_station_2 = Station.new('test-Station-22')
puts test_station_2.name
puts 'количество инстансов класса Station'
puts Station.instances
