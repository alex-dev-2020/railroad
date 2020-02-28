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
  puts 'Главное меню :'
  puts "\n 1.Создать станцию \n 2.Создать поезд \n 3.Создать маршрут и управлять станциями в нем (добавить, удалить) \n 4.Назначить маршрут поезду \n 5.Добавить вагоны к поезду \n 6.Отцепить вагоны от поезда \n 7.Переместить поезд по маршруту вперед и назад \n 8.Просмотреть список станций и список поездов на станции\n"
end
case user_choice
when 1
  create_station
when 2
  create_train
when 3
  create_route
when 4
  accept_route
when 5
  add_wagon
when 6
  detach_wagon
when 7
  move_train
when 8
  show_train_list
else
  main_menu
end

user_choice = gets.chomp.to_s

