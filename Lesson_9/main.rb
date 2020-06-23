require_relative 'railroad_control'
require_relative 'railroad_menu'

menu = RailroadMenu.new


loop do

  puts '---'
  menu.print_menu
  print 'Введите индекс действия: '
  action_index = gets.chomp.strip

  next if action_index.empty?

  action_index = action_index.to_i
  break if action_index == menu.exit_index

  next if menu.action_menu[action_index].nil? || menu.message(action_index).nil?

  begin
    result = railway_controller.public_send menu.message(action_index)
  rescue StandardError => error
    puts "Ошибка: #{error.backtrace.inspect}"
  else
    puts result
  end
end