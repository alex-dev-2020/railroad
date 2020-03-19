require_relative 'railroad'
require_relative 'train'
require_relative 'station'
require_relative 'wagon'
require_relative 'route'
require_relative 'pass_train'
require_relative 'cargo_train'
require_relative 'pass_wagon'
require_relative 'cargo_wagon'
require_relative 'instance_counter'
require_relative 'made_by'
#
# # Создать программу в файле main.rb, которая будет позволять пользователю через текстовый интерфейс делать следующее:
#
my_railroad = Railroad.new
my_railroad.seed
# puts my_railroad.stations
# puts my_railroad.trains
# puts my_railroad.routes

main_menu = {1 => 'Создать станцию',
             2 => 'Создать поезд',
             3 => 'Создать маршрут и управлять станциями в нем (добавить, удалить)',
             4 => 'Назначить маршрут поезду',
             5 => 'Добавить вагоны к поезду',
             6 => 'Отцепить вагоны от поезда',
             7 => 'Переместить поезд по маршруту вперед и назад',
             8 => 'Просмотреть список станций и список поездов на станции',
             0 => 'Завершение работы'
}

loop do
  puts 'Главное  меню.'
  puts 'Введите номер для выбора действия или 0 для выхода:'


  user_choice = my_railroad.selection(main_menu)

  case user_choice
  when '1'
    puts 'Создание станции '
    my_railroad.create_station
  when '2'
    puts 'Создание поезда '
    my_railroad.create_train
  when '3'
    puts 'Создание маршрута и управление станциями в нем '
    my_railroad.create_route
  when '4'
    puts 'Назначение маршрута поезду'
    my_railroad.accept_route
  when '5'
    puts 'Добавление вагона к поезду'
    my_railroad.add_wagon
  when '6'
    puts 'Отцепление  вагонов от поезда'
    my_railroad.detach_wagon
  when '7'
    puts 'Перемещение поезда по маршруту'
    my_railroad.move_train
  when '8'
    puts 'Вывод списка поездов на станции'
    my_railroad.show_train_list
  when '0'
    puts 'Завершение работы.'
    break
  end
end


