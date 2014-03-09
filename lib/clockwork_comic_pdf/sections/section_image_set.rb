require_relative 'section'

module ClockworkComicPDF
  module Sections
    # The section class for image sets
    class SectionImageSet < Section
      include SectionLayout
      attr_accessor :print_intro, :intro_options, :img_path, :print_titles,
                    :min_spacing
    end
  end
end
