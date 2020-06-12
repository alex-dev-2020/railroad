# frozen_string_literal: true

require_relative 'railroad_control'
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
require_relative 'valid'

my_railroad = Railroad.new

main_menu = { 1 => 'Создать станцию',
              2 => 'Создать поезд',
              3 => 'Создать маршрут',
              4 => 'Добавить станцию в маршрут',
              5 => 'Удалить станцию из маршрута',
              6 => 'Назначить маршрут поезду',
              7 => 'Перемещение поезда по маршруту вперед/назад',
              8 => 'Получить список вагонов у поезда',
              9 => 'Добавить вагоны к поезду',
              10 => 'Загрузить вагон',
              11 => 'Разгрузить вагон',
              12 => 'Отцепить вагоны от поезда',
              13 => 'Просмотреть список станций и список поездов на станции',
              14 => 'Генерация тестовых объектов',
              0 => 'Завершение работы' }

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
    puts 'Создать маршрут'
    my_railroad.create_route
  when '4'
    puts 'Добавить станцию в маршрут'
    my_railroad.add_station_to_route
  when '5'
    puts ' '
    my_railroad.delete_station_from_route
  when '6'
    puts 'Назначение маршрута поезду'
    my_railroad.add_route_to_train
  when '7'
    puts 'Переместить поезд по маршруту вперед/назад'
    my_railroad.move_train
  when '8'
    puts 'Получить список вагонов у поезда'
    my_railroad.print_trains_wth_wagons
  when '9'
    puts 'Добавление вагона к поезду'
    my_railroad.add_wagon
  when '10'
    puts 'Загрузить вагон'
    my_railroad.load_wagon
  when '11'
    puts 'Разгрузить вагон'
    my_railroad.unload_wagon
  when '12'
    puts 'Отцепление  вагонов от поезда'
    my_railroad.detach_wagon
  when '13'
    puts 'Вывод списка поездов на станции'
    my_railroad.show_train_list
  when '14'
    puts 'Генерация тестовых объектов'
    my_railroad.seed
  when '0'
    puts 'Завершение работы.'
    break
  end
end
