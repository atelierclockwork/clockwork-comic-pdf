require_relative 'to_points'
require_relative 'errors'
require_relative 'option_validation'

module ClockworkComicPDF
  # this contains the size, file path, and size of the cover
  class Cover
    include OptionValidation
    attr_accessor :path, :file
    attr_reader :size

    def size=(size)
      unless size.is_a?(Array) && size.count == 2
        throw InvalidValueError.new 'Cover size must contain exactly 2 values'
      end
      @size = size.to_points
    end

    def initialize(options = {})
      load_options options
    end
  end
end
