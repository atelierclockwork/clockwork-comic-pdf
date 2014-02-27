require_relative 'to_points'
require_relative 'errors'
require_relative 'option_validation'

module ClockworkComicPDF
  # this contains the size, file path, and size of the cover
  class Cover
    include OptionValidation
    attr_reader :size
    def size=(size)
      unless size.is_a?(Array) && size.count == 2
        throw InvalidValueError.new 'Cover size must contain exactly 2 values'
      end
      size[0] = size[0].to_points
      size[1] = size[1].to_points
      @size = size
    end

    attr_reader :path
    def path=(path)
      @path = path.to_s
    end

    attr_reader :file
    def file=(file)
      @file = file.to_s
    end

    def validate
      fail InvalidValueError, 'Cover Must specify a file' unless file
      fail InvalidValueError, 'Cover must specify a size' unless size
      fail InvalidValueError, 'Cover must specify a path' unless path
    end

    def initialize(options = {})
      check_options(options.keys, [:size, :path, :file])
      self.path = options[:path]
      self.size = options[:size]
      self.file = options[:file]
    end
  end
end
