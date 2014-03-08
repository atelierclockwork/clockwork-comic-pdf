require_relative 'option_validation'

module ClockworkComicPDF
  # convienience class for parsing and holding version objects
  class Versions < Array
    def initialize(versions)
      versions.each do |param|
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
    attr_accessor :trim_offset, :print_cover, :name, :dpi

    def validate
      fail InvalidValueError, 'Each version must contain a name' unless name
      fail InvalidValueError,
           'Each version must contain a name' if name.length == 0
      fail InvalidValueError,
           'each version must specify a dpi value' unless dpi
    end

    def initialize(options = {})
      load_options options
    end
  end
end
