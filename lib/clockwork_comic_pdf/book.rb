require_relative 'to_points'
require_relative 'page_header'
require_relative 'errors'
require_relative 'cover'
require_relative 'version'
require_relative 'option_validation'
require_relative 'book_validation'

module ClockworkComicPDF
  # variable storage for the book class
  class Book
    include OptionValidation, BookValidation

    def initialize(options = {})
      load_options options
    end

    attr_accessor :toc_font_size, :print_toc, :font, :margin, :print_pagenum,
                  :page_header, :cover, :base_file_name, :sections, :versions,
                  :section_intro_options

    attr_reader :font_size, :info, :page_size, :offset_from_spine

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

    def offset_from_spine=(offset_from_spine)
      @offset_from_spine = offset_from_spine.to_points
    end
  end
end
