require 'yaml'

class RailroadMenu
    
  attr_reader :action_menu, :exit_index

  def initialize
    @action_menu = parse_menu_from_file('menu.yml')
    @exit_index = nil
  end

  def print_menu
    puts 'Выберите действие:'
    action_menu.each_with_index do |item, index|
      case item[:type]
      when :separator then puts item[:title].nil? ? '' : "\n[#{item[:title]}]"
      when :exit
        @exit_index = index
        print_menu_item(index, item)
      else print_menu_item(index, item)
      end
    end
  end
    def parse_menu_from_file(file_name)
    raise StandardError, "Файл меню не найден (#{file_name})" unless File.exist?(file_name)
    raise StandardError, "Файл меню пустой (#{file_name})" if File.zero?(file_name)

    menu_items = YAML.load_file(file_name)
    raise StandardError, 'Ошибка формата меню' unless menu_items.is_a?(Array)

    menu_items
  rescue StandardError => error
    puts error
  end

  def print_menu_item(index, item)
    puts "[#{index}] #{item[:title]}"
  end

  def title(index)
    action_menu[index][:title]
  end

  def message(index)
    action_menu[index][:message]
  end
  
end
