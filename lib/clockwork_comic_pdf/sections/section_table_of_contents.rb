require_relative 'section'

module ClockworkComicPDF
  module Sections
    # The Table of contents section class
    class SectionTableOfContents < Section
      include SectionLayout
      def include_in_toc
        false
      end
    end
  end
end
