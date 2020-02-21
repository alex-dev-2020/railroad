require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'


# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
class Railroad


  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  puts "Главное меню :"
  puts " 1.Создать станцию \n 2.Создать поезд \n 3.Создать маршрут и управлять станциями в нем (добавить, удалить) \n 4.Назначить маршрут поезду \n 5.Добавить вагоны к поезду \n 6.Отцепить вагоны от поезда \n 7.Переместить поезд по маршруту вперед и назад \n 8.Просмотреть список станций и список поездов на станции\n"

  user_choice = gets.chomp.to_i
  if user_choice == 1
    puts 'Введите название станции'
    station_name = gets.chomp.to_s
    new_station = Station.new(station_name)
    # only for test purspose
    puts new_station.name
    # @stations <<  new_station
  elsif user_choice == 2
    puts 'Введите тип поезда'
    train_type = gets.chomp.to_s
    puts 'Введите номер поезда'
    train_name = gets.chomp.to_s
    if train_type == 'cargo'
      new_train = CargoTrain.new(train_name)
    else
      new_train = PassTrain.new(train_name)
    end
    # only for test purspose
    puts new_train
  elsif user_choice == 3
    puts 'Введите название первой станции маршрута'
    first_station_ = gets.chomp.to_s
    puts 'Введите название последней станции маршрута'
    last_station_ = gets.chomp.to_s
    new_route = Route.new(first_station_, last_station_)
    # only for test purspose
    puts new_route.stations
  end
end
