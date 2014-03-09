require_relative 'section'
require_relative 'section_layout'

module ClockworkComicPDF
  module Sections
    # The Plain text section class
    class SectionText < Section
      include SectionLayout
      attr_accessor :file
    end
  end
end
