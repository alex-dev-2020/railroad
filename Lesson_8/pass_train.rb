# frozen_string_literal: true
class PassTrain < Train
  def type
    :pass
  end

  def add_wagon(wagon)
    super(wagon) if wagon.is_a?(PassWagon)
  end
end
