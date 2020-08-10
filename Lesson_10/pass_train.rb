# frozen_string_literal: true

require_relative 'train'
# require_relative "validation"

class PassTrain < Train
  # include Validation

  # validate :number, :format, NUMBER_FORMAT, message: "Неверный формат номера"
  # validate :made_by, :format, MAKER_FORMAT, message: "Неверный формат названия"
  def type
    :pass
  end

  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(PassWagon)
  end
end
