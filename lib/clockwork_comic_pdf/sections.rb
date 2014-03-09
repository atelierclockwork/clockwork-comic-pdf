require_relative 'option_validation'
require_relative 'sections/section_rich_text'
require_relative 'sections/section_text'
require_relative 'sections/section_image_set'
require_relative 'sections/section_seperator'
require_relative 'sections/section_table_of_contents'

module ClockworkComicPDF
  # this stores the data for each section of the book
  class SectionArray < Array
    include OptionValidation

    def initialize(sections)
      sections.each do |section|
        self << section_from_options(section)
      end
    end

    def type_map
      { text: ClockworkComicPDF::Sections::SectionText,
        rich_text: ClockworkComicPDF::Sections::SectionRichText,
        table_of_contents: ClockworkComicPDF::Sections::SectionTableOfContents,
        seperator: ClockworkComicPDF::Sections::SectionSeperator,
        image_set: ClockworkComicPDF::Sections::SectionImageSet }
    end

    def section_from_options(options = {})
      if type_map.keys.include? options[:section_type]
        type_map[options[:section_type]].new(options)
      else
        fail UndefinedKeyError, "invalid type: #{options[:section_type]}"
      end
    end
  end
end
