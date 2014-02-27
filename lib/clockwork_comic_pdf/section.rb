require_relative 'option_validation'

module ClockworkComicPDF
  # this stores the data for each section of the book
  class Sections
    include OptionValidation
    def front_matter
      @front_matter ||= []
    end
    attr_writer :front_matter

    def body
      @body ||= []
      @body
    end
    attr_writer :body

    def end_matter
      @end_matter ||= []
      @end_matter
    end
    attr_writer :end_matter

    def parse_sections(sections)
      parsed_sections = []
      sections.each do |section|
        parsed_sections << section_by_type(section)
      end
      parsed_sections
    end

    def section_by_type(section)
      case section[:type]
      when :comic_pages
        return SectionComicPages.new(section)
      when :text_box
        return SectionTextBox.new(section)
      when :formatted_text_box
        return SectionFormattedTextBox.new(section)
      else
        fail InvalidKeyError, "#{section[:type]} is not a valid section type"
      end
    end

    def validate
      [front_matter, body, end_matter].each do |chunk|
        chunk.each { |sec| sec.validate }
      end
    end

    def print_pdf(options = {})
      [front_matter, body, end_matter].each do |chunk|
        chunk.each { |sec| sec.print_pdf(options) }
      end
    end

    def initialize(options = {})
      check_options(options.keys, [:front_matter, :body, :end_matter])
      self.front_matter = parse_sections(options[:front_matter])
      self.body = parse_sections(options[:body])
      self.end_matter = parse_sections(options[:end_matter])
    end
  end

  # this is the base class for sections data that stores common section info
  class Section
    include OptionValidation
    attr_writer :print_section_intro
    def print_section_intro
      @print_section_intro = false if @print_section_intro.nil?
      @print_section_intro
    end

    attr_accessor :type
    attr_accessor :name

    def valid_options
      @valid_options = [:print_section_intro, :type, :name]
    end

    def req_keys
      @required_keys = { name: @name }
    end

    def validate
      check_required(req_keys)
    end

    def initialize(options = {})
      self.name = options[:name]
      self.type = options[:type]
      self.print_section_intro = options[:print_section_intro]
    end
  end

  # Comic Pages section
  class SectionComicPages < Section
    def valid_options
      super
      @valid_options << :directory
    end

    def req_keys
      super
      @required_keys[:directory] = @directory
      @required_keys
    end

    attr_accessor :directory

    def initialize(options = {})
      super
      self.directory = options[:directory]
    end
  end

  # text box method
  class SectionTextBox < Section
    attr_accessor :file, :options

    def valid_options
      super
      @valid_options << :file
      @valid_options << :options
    end

    def req_keys
      super
      @required_keys[:file] = @file
      @required_keys[:options] = @options
      @required_keys
    end

    def initialize(options = {})
      super
      self.options = options[:options]
      self.file = options[:file]
    end
  end

  # formatted text box method
  class SectionFormattedTextBox < SectionTextBox
  end
end
