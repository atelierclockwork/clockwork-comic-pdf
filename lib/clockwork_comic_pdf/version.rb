require_relative 'option_validation'

module ClockworkComicPDF
  # convienience class for parsing and holding version objects
  class Versions < Array
    def initialize(options)
      options.each do |param|
        self << Version.new(param)
      end
    end

    def validate
      each { |version| version.validate }
    end
  end

  # stores version information for PDF generation
  # includes name, length, dpi and a toggle for printing the cover
  class Version
    include OptionValidation
    attr_reader :name
    def name=(name)
      @name = name.to_s
    end

    attr_reader :dpi
    def dpi=(dpi)
      @dpi = dpi.to_i
    end

    def print_cover
      @print_cover = false if @print_cover.nil?
      @print_cover
    end
    attr_writer :print_cover

    def trim_offset
      @trim_offset = false if @trim_offset.nil?
      @trim_offset
    end
    attr_writer :trim_offset

    def validate
      fail InvalidValueError, 'Each version must contain a name' unless name
      fail InvalidValueError,
           'Each version must contain a name' if name.length == 0
      fail InvalidValueError,
           'each version must specify a dpi value' unless dpi
    end

    def initialize(options = {})
      check_options(options.keys, [:name, :dpi, :print_cover, :trim_offset])
      self.name = options[:name]
      self.dpi = options[:dpi]
      self.trim_offset = options[:trim_offset]
      self.print_cover = options[:print_cover]
    end
  end
end
