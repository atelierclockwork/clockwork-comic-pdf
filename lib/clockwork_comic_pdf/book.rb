require_relative 'to_points'
require_relative 'page_header'
require_relative 'errors'
require_relative 'cover'
require_relative 'version'
require_relative 'option_validation'
require_relative 'book_validation'
require_relative 'book_init'

module ClockworkComicPDF
  # variable storage for the book class
  class Book
    include OptionValidation, BookValidation, BookInit
    def font
      @font ||= 'Helvetica'
    end
    attr_writer :font

    def font_size
      @font_size ||= 12
    end

    def font_size=(font_size)
      @font_size = font_size.to_points unless font_size.nil?
    end

    attr_accessor :base_file_name

    def info
      @info ||= {}
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

    def page_size
      @page_size ||= [{ val: 8.5, type: :in },
                      { val: 11, type: :in }]
    end

    def page_size=(page_size)
      page_size = page_size.to_a
      page_size.each do |dim|
        page_size[page_size.find_index dim] = dim.to_points
      end
      @page_size = page_size
    end

    def margin
      @margin ||= { val: 0.25, type: :in }
    end

    def margin=(margin)
      @margin = []
      margin = [margin] unless margin.is_a? Array
      unless margin.count == 4 || margin.count == 1
        fail InvalidValueError 'Margin must contain 1 or 4 values'
      end
      margin.each_index do |i|
        @margin[i] = margin[i].to_points
      end
      @margin
    end

    def offset_from_spine
      @offset_from_spine ||= 0
    end

    def offset_from_spine=(offset_from_spine)
      @offset_from_spine = offset_from_spine.to_points
    end

    def print_toc
      @print_toc = true if @print_toc.nil?
      @print_toc
    end
    attr_writer :print_toc

    def print_pagenum
      @print_pagenum = true if @print_toc.nil?
      @print_pagenum
    end
    attr_writer :print_pagenum
    attr_accessor :page_header
    attr_accessor :cover

    def versions
      @versions ||= []
    end
    attr_writer :versions

    attr_accessor :sections
  end
end
