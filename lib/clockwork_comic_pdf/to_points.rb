require 'prawn/measurement_extensions'

# adds point conversion function for hash values
class String
  def to_points
    value, unit = scan(/[\d\.]+|\w+/)
    value = value.to_f
    value.send(unit) if value.respond_to?(unit)
  end
end

# adds point conversion for arrays, converts every array element to points
class Array
  def to_points
    map(&:to_points)
  end
end

# returns itself as is for all numeric classes
class Numeric
  def to_points
    self
  end
end
