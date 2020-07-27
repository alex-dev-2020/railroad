# frozen_string_literal: true

# require_relative 'made_by'

class Wagon
  attr_reader :type, :number
  include InstanceCounter
  include Valid
  include MadeBy

  def generate_number
    srand.to_s.slice(0...10)
  end
end
