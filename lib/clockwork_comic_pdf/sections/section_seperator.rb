require_relative 'section'

module ClockworkComicPDF
  module Sections
    # the blank seperator section
    class SectionSeperator < Section
      attr_accessor :num_pages

      def include_in_toc
        false
      end
    end
  end
end
