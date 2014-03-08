require 'prawn/measurement_extensions'

# adds point conversion function for hash values
class Hash
  def to_points
    if size == 2 && self[:val] && self[:type]
      return self[:val].to_f.send(self[:type])
    end
    fail ClockworkComicPDF::UndefinedKeyError,
         'measurement must contain only :val and :type'
  end
end

# adds point conversion for arrays, converts every array element to points
class Array
  def to_points
    map { |v| v.to_points }
  end
end

# returns itself as is for all numeric classes
class Numeric
  def to_points
    self
  end
end
