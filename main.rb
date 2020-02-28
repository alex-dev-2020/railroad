require_relative 'railroad'
require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'
#
#
# # Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#
my_railroad = Railroad.new
my_railroad.seed
# puts my_railroad.stations
# puts my_railroad.trains
# puts my_railroad.routes

def main_menu
  puts 'Главное меню :'
  puts "\n 1.Создать станцию \n 2.Создать поезд \n 3.Создать маршрут и управлять станциями в нем (добавить, удалить) \n 4.Назначить маршрут поезду \n 5.Добавить вагоны к поезду \n 6.Отцепить вагоны от поезда \n 7.Переместить поезд по маршруту вперед и назад \n 8.Просмотреть список станций и список поездов на станции\n"
end


main_menu
user_choice = gets.chomp.to_i
case user_choice
when 1
  puts '1.Создание станции '
  my_railroad.create_station
when 2
  puts '2.Создание поезда '
  my_railroad.create_train
when 3
  puts '3.Создание маршрута и управление станциями в нем '
  my_railroad.create_route
when 4
  puts '4.Назначение маршрута поезду'
  my_railroad.accept_route
when 5
  puts '5.Добавление вагона к поезду'
  my_railroad.add_wagon
when 6
  puts 'Отцепление  вагонов от поезда'
  my_railroad.detach_wagon
when 7
  puts '7.Перемещение поезда по маршруту'
  my_railroad.move_train
when 8
  puts '8. Вывод списка поездов на станции'
  my_railroad.show_train_list
else
  puts 'Возврат в главное меню '
  main_menu
end


