require_relative '../option_validation'

module ClockworkComicPDF
  module Sections
    # The Plain text section class
    # this is the base class for sections data that stores common section info
    class Section
      include OptionValidation

      attr_accessor :include_in_toc, :name

      def validate
        # check_required(req_keys)
      end

      def print
      end

      def initialize(options = {})
        options.delete(:section_type)
        load_options options
        puts YAML.dump(self)
      end
    end
  end
end
