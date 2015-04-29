class Point
  attr_accessor :latitude, :longitude, :distance, :elevation

  private

  def initialize(params = nil)
    params ||= {}
    defaults
    params.each { |key,value| instance_variable_set("@#{key}", value) }
  end

  def defaults
    self.distance = 0
  end
end