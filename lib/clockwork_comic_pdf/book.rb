require_relative 'to_points'
require_relative 'page_header'
require_relative 'errors'
require_relative 'cover'
require_relative 'version'
require_relative 'option_validation'
require_relative 'book_validation'
require_relative 'sections'
require_relative 'print_version'

module ClockworkComicPDF
  # variable storage for the book class
  class Book
    include BookValidation

    attr_accessor :font, :info, :page_size, :base_file_name, :margin, :font_size
    :spine_offset

    def initialize(**options)
      set_defaults
      book_layout(options)
    end

    def set_defaults
      @font = 'Helvetica'
      @font_size = 12
      @info  = { Creator: 'Clockwork Comic PDF Engine',
                 Producer: 'Prawn' }
      @page_size = ['8.5 in', '11 in'].to_points
      @margin = '0.5 in'.to_points
      @spine_offset = 0
    end

    def book_layout(spine_offset:@spine_offset, page_size:@page_size,
                    margin:@margin, **options)
      @page_size = page_size.to_points
      @margin = margin.to_points
      @spine_offset = spine_offset.to_points
      file_details(options)
    end

    def file_details(base_file_name:, info:@info, **options)
      @base_file_name = base_file_name.to_s
      @info = info.to_hash
      text_properties(options)
    end

    def text_properties(font:@font, font_size:@font_size, **options)
      @font = font.to_s
      @font_size = font_size.to_points
      last_call options
    end

    def last_call(**options)
      puts YAML.dump options
    end

    # :print_pagenum:
    #   :default: true
    #   :type: Boolean
    # :page_header:
    #   :type: ClockworkComicPDF::PageHeader
    #   :required: false
    # :versions:
    #   :type: ClockworkComicPDF::Versions
    #   :default: []
    # :sections:
    #   :type: ClockworkComicPDF::SectionArray
    #   :default: []
    # :font_size:
    #   :type: Points
    #   :default: 12
    # :cover:
    #   :type: ClockworkComicPDF::Cover
    #   :required: false
    # :section_intro_options:
    #   :type: Hash
    #   :default:
    #     :align: :center
    #     :valign: :center
    #     :at: :bounds_top_left
    #     :width: :bounds_width
    #     :height: :bounds_height
    #     :size: 24

    def print
      puts YAML.dump(self)
      # validate
      # versions.each { |v| print_version(v) }
    end

    attr_accessor :toc_font_size, :print_toc, :font, :margin, :print_pagenum,
                  :page_header, :cover, :base_file_name, :sections, :versions,
                  :section_intro_options

    attr_reader :font_size, :info, :page_size, :spine_offset

    def font_size=(font_size)
      @font_size = font_size.to_points
    end

    def info=(info)
      if info.is_a? Hash
        info[:CreationDate] = Time.now
        info[:Creator] = 'Clockwork Comic PDF Engine'
        info[:Producer] = 'Prawn'
      else
        fail InvalidValueError, 'Information must be set as a Hash value'
      end
      @info = info
    end

    def page_size=(page_size)
      @page_size = page_size.to_points
    end

    def margin=(margin)
      margin = [margin] unless margin.is_a? Array
      unless margin.count == 4 || margin.count == 1
        fail InvalidValueError 'Margin must contain 1 or 4 values'
      end
      @margin = margin.to_points
    end

    def spine_offset=(spine_offset)
      @spine_offset = spine_offset.to_points
    end

    private

    def print_version(version)
      PrintVersion.new(book: self, version: version)
    end
  end
end
