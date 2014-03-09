require_relative 'option_validation'

module ClockworkComicPDF
  # this stores the data for each section of the book
  class Sections < Array
    include OptionValidation

    def initialize(sections)
      sections.each do |section|
        self << section_from_options(section)
      end
    end

    def validate
      each { |section| section.validate }
    end

    def section_from_options(options)
      case section_options[:type]
      when :text then return TextSection.new(options)
      when :rich_text then return RichTextSection.new(options)
      when :table_of_contents then return TableOfContentsSection.new(options)
      when :seperator then return SeperatorSection.new(options)
      when :image_set then return ImageSetSection.new(options)
      else fail InvalidKeyError, "invalid type: #{section_options[:type]}"
      end
    end
  end

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
      load_options options
      puts self
    end
  end

  # includes the parsing logic for converting the layout hash passed in here to
  # a Prawn friendly hash
  module SectionLayout
    attr_accessor :layout
  end

  # The section class for image sets
  class ImageSetSection < Section
    include SectionLayout
    attr_accessor :print_intro, :intro_options, :img_path, :print_titles,
                  :min_spacing
  end

  # the blank seperator section
  class SectionSeperator < Section
    attr_accessor :num_pages

    def include_in_toc
      false
    end
  end

  # The Plain text section class
  class TextSection < Section
    include SectionLayout
    attr_accessor :file
  end

  # The Rich text section class
  class RichTextSection < TextSection
  end

  # The Table of contents section class
  class TableOfContentsSection < Section
    include SectionLayout

    def include_in_toc
      false
    end
  end
end
