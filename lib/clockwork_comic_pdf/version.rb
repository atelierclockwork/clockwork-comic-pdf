require_relative 'option_validation'

module ClockworkComicPDF
  # Convienience class for instantiating all of the version objects
  class Versions < Array
    # replaces the initializer method with one that converts all of the
    # items passed into it into a CCPDF version file
    def initialize(versions)
      versions.each do |v|
        if v.is_a? ClockworkComicPDF::Version then self << v
        elsif v.is_a? Hash then self << Version.new(v)
        else
          fail InvalidValueError, "#{v.class} not supported by Versions array"
        end
      end
    end
  end

  # stores version information for PDF generation
  # includes name, length, dpi and a toggle for printing the cover
  class Version
    include OptionValidation
    attr_accessor :trim_offset, :print_cover, :name, :dpi

    def initialize(options = {})
      load_options options
    end
  end
end
