require 'prawn/measurement_extensions'

# adds point conversion function for hash values
class Hash
  def to_points
    if size == 2 && self[:val] && self[:type]
      return self[:val].to_f.send(self[:type])
    end
    puts self
    fail ClockworkComicPDF::UndefinedKeyError,
         'measurement must contain only :val and :type'
  end
end

# returns itself as is for fixnum
class Fixnum
  def to_points
    self
  end
end

# returns itself as is for Float
class Float
  def to_points
    self
  end
end
