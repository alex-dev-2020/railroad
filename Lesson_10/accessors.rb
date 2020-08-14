# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # объявляем метод для любого числа аргументов
    def attr_accessor_with_history(*params)
      # enumerate each param 'cause undefined number of params
      # to create  getter/setter
      params.each do |param|
        # getter creation with p
        define_method(param) do
          instance_variable_get("@#{param}")
        end
        #  все еще находясь в блоке - по названию аргументов
        define_method("#{param}_history") do
          # пилим геттер, но уже для переменной имя_аргумента_history
          instance_variable_get("@#{param}_history")
        end
        # теперь уже пилим сеттер -  "зеркально" для стр. 13
        define_method("#{param}=") do |value|
          instance_variable_set("@#{param}", value)
          # получаем значения ( т.к.до все еще в блоке) переменных по маске имя_аргумента_history - или пустой массив
          history_values = instance_variable_get("@#{param}_history") || []
          # сеттер уже для имя_аргумента_history - что за странный синтаксис ! ! !
          # сеттер "зеркально" для стр. 34
          instance_variable_set("@#{param}_history", history_values << value)
        end
      end
    end

    # метод strong_attr_accessor
    def strong_attr_accessor(attr_name, attr_class)
      # геттер
      define_method("#{attr_name}") do
        instance_variable_get("@#{attr_name}")
      end
      define_method("#{attr_name}=") do |value|
        # проверяем принадлежность типа
        raise TypeError, "Тип должен быть #{attr_class}" unless value.is_a?(attr_class)

        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end
