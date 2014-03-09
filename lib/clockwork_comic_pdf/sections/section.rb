require_relative '../option_validation'

module ClockworkComicPDF
  module Sections
    # this is the base class for sections data that stores common section info
    class Section
      include OptionValidation

      attr_accessor :include_in_toc, :name

      def print
      end

      def initialize(options = {})
        options.delete(:section_type)
        load_options options
      end
    end
  end
end
