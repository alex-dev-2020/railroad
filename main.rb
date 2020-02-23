require_relative 'railroad'
require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'


# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:

my_railroad = Railroad.new
my_railroad.seed
puts my_railroad.stations
puts my_railroad.trains
puts my_railroad.routes

def main_menu
  puts "Главное меню :"
  puts "\n 1.Создать станцию \n 2.Создать поезд \n 3.Создать маршрут и управлять станциями в нем (добавить, удалить) \n 4.Назначить маршрут поезду \n 5.Добавить вагоны к поезду \n 6.Отцепить вагоны от поезда \n 7.Переместить поезд по маршруту вперед и назад \n 8.Просмотреть список станций и список поездов на станции\n"
end

main_menu
user_choice = gets.chomp.to_s
if user_choice == '1'
  puts 'Введите название станции'
  station_name = gets.chomp.to_s
  new_station = Station.new(station_name)
  my_railroad.stations << new_station
elsif user_choice == '2'
  puts 'Введите тип поезда'
  train_type = gets.chomp.to_s
  puts 'Введите номер поезда'
  train_name = gets.chomp.to_s
  if train_type == 'cargo'
    new_train = CargoTrain.new(train_name)
  else
    new_train = PassTrain.new(train_name)
  end
  my_railroad.trains << new_train
elsif user_choice == '3'
  puts 'Введите название первой станции маршрута'
  first_station = gets.chomp.to_s
  puts 'Введите название последней станции маршрута'
  last_station = gets.chomp.to_s
  new_route = Route.new(first_station, last_station)
  my_railroad.routes << new_route
elsif user_choice == '4'
  #n 4.Назначить маршрут поезду
  # Нужно вывести список текущих поездов
  puts 'Список существующих поездов:'
  my_railroad.trains.each_index { |index| print index + 1, ' ', my_railroad.trains.at(index), puts }
  puts "\nВведите номер  нужного поезда "
  accepting_train_index = gets.chomp.to_i - 1
  accepting_train = my_railroad.trains.at(accepting_train_index)
  #  only for test purpose
  puts accepting_train
  #  нужно вывести список текущих маршрутов
  puts 'Список текущих маршрутов:'
  my_railroad.routes.each_index { |index| print index + 1, ' ', my_railroad.routes.at(index), puts }
  puts "\nВведите номер требуемого маршрута"
  accepted_route_index = gets.chomp.to_i - 1
  accepted_route = my_railroad.routes.at(accepted_route_index)
  #  only for test purpose
  puts accepted_route
  accepting_train.accept_route(accepted_route)
  #  only for test purpose
  puts accepting_train.current_station.name
end