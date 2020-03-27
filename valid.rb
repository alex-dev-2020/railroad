module  Valid
  def valid?
    self.validate!
    true
  rescue
    false
  end
end