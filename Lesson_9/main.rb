require_relative 'railroad_control'
require_relative 'railroad_menu'


menu = RailroadMenu.new
controller = RailroadControl.new


loop do

  puts '---'
  menu.print_menu
  print 'Введите индекс действия: '
  action_index = gets.chomp.strip
  # controller.clear_screen

  next if action_index.empty?

  action_index = action_index.to_i
  break if action_index == menu.exit_index

  next if menu.action_menu[action_index].nil? || menu.message(action_index).nil?

  begin
    result = controller.public_send menu.message(action_index)
  rescue StandardError => error
    # controller.clear_screen
    puts "Ошибка: #{error.backtrace.inspect}"
  else
    # controller.clear_screen
    result
  end
end