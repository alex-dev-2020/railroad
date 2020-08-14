# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # define method for undefined number of params
    def attr_accessor_with_history(*params)
      # enumerate each param 'cause undefined number of params to create  getter/setter
      params.each do |param|
        # getter creation for param
        define_method(param) do
          instance_variable_get("@#{param}")
        end
        # still being inside block enumerate to create for param_history values
        define_method("#{param}_history") do
          # getter creation for param_history value
          instance_variable_get("@#{param}_history")
        end
        # setter creation -  symmetric to line 13
        define_method("#{param}=") do |value|
          instance_variable_set("@#{param}", value)
          # still being inside block enumerate to get history values or []
          history_values = instance_variable_get("@#{param}_history") || []
          # setter creation with saving current value - symmetric to line 20
          instance_variable_set("@#{param}_history", history_values << value)
        end
      end
    end

    # strong_attr_accessor
    def strong_attr_accessor(attr_name, attr_class)
      # getter creation
      define_method("#{attr_name}") do
        instance_variable_get("@#{attr_name}")
      end
      define_method("#{attr_name}=") do |value|
        # Type check before setter creation
        raise TypeError, "Тип должен быть #{attr_class}" unless value.is_a?(attr_class)

        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end
