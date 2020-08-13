# frozen_string_literal: true

# require_relative 'made_by'
require_relative 'validation'
require_relative 'accessors'

class Wagon
  include InstanceCounter
  include MadeBy
  include Accessors

  attr_reader :type, :number
  attr_accessor_with_history :wagon_using_history


  def generate_number
    srand.to_s.slice(0...10)
  end
end
