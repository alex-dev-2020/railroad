require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'


# Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
puts "Главное меню :"
puts " 1.Создать станцию \n 2.Создать поезд \n 3.Создать маршрут и управлять станциями в нем (добавить, удалить) \n 4.Назначить маршрут поезду \n 5.Добавить вагоны к поезду \n 6.Отцепить вагоны от поезда \n 7.Переместить поезд по маршруту вперед и назад \n 8.Просмотреть список станций и список поездов на станции\n"

user_choice = gets.chomp.to_i
if user_choice == 1
  puts 'Введите название станции'
  station_name = gets.chomp
  @new_station = Station.new(station_name)
elsif user_choice == 2
  puts 'Введите тип поезда'
  train_type = gets.chomp.to_s
  if train_type == 'cargo'
    new_train = PassTrain.new
  else
    new_train = CargoTrain.new
  end
end

