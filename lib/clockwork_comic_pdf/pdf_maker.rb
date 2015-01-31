require_relative 'book'
require_relative 'version'
require_relative 'measurement_parser'
require_relative 'pdf_section_maker'
require_relative 'pdf_toc_maker'
require 'prawn'

module ClockworkComicPDF
  # TODO: rewrite section parsing code
  # this parses the sections of a book into a pdf file
  class PDFMaker
    include MeasurementParser, PDFSectionMaker, PDFTocMaker
    attr_accessor :book, :content_start, :debug, :printing_body, :current_page,
                  :trim_offset

    attr_writer :page_index
    def page_index
      @page_index ||= []
    end

    def initialize(book)
      @book = book
    end

    def print
      book.validate
      book.versions.each do |version|
        self.content_start = nil
        self.printing_body = false
        self.current_page = nil
        self.page_index = nil
        self.debug = false
        print_version(version)
      end
    end

    def print_version(version)
      self.trim_offset = version.trim_offset
      pdf = Prawn::Document.new(info: book.info, font_size: book.font_size,
                                skip_page_creation: true)
      print_sections(pdf, version)
      print_cover(pdf, version) if version.print_cover
      pdf.render_file "#{book.base_file_name} - #{version.name}.pdf"
    end

    def print_cover(_pdf, _version)
      # pdf.go_to_page 0
      # return if book.cover.nil?
      # cover = book.cover
      # pdf.start_new_page(size: cover.size, margin: 0)
      # pdf.image("#{cover.path}/#{version.name}/#{cover.file}",
      #           at: pdf.bounds.top_left, scale: 72.0 / version.dpi.to_f)
    end

    def new_page(pdf)
      if trim_offset then make_trim_page(pdf)
      else make_offset_page(pdf)
      end
      pdf.font(book.font)
      print_body_page(pdf) if printing_body
      debug_stroke(pdf) if debug
    end

    def make_offset_page(pdf)
      margin = Array.new(book.margin)
      if pdf.page_number.odd? then margin[1] += book.spine_offset
      else margin[3] += book.spine_offset
      end
      pdf.start_new_page(size: book.page_size, margin: margin)
    end

    def make_trim_page(pdf)
      margin = Array.new(book.margin)
      pdf.start_new_page(size: [book.page_size[0] - book.spine_offset,
                                book.page_size[1]],
                         margin: margin)
    end

    def print_body_page(pdf)
      self.current_page += 1
      print_header(pdf) unless book.page_header.nil?
      print_page_num(pdf) if book.print_pagenum
    end

    # def print_header(pdf)
    #   head = book.page_header
    #   options = { size: head.size, align: head.align,
    #               width: pdf.bounds.width }
    #   text = pdf.page_number.even? ? head.left_text : head.right_text
    #   options[:at] = [pdf.bounds.left, pdf.bounds.top + 0.25.in]
    #   options[:valign] = :center
    #   options[:height] = 0.25.in
    #   if options[:align] == :alternating
    #     options[:align] = even_page ? :left : :right
    #   end
    #   pdf.text_box(text, options)
    # end

    def print_page_num(pdf)
      options = { at: pdf.bounds.bottom_left,
                  width: pdf.bounds.width,
                  align: :center,
                  size: 8 }
      options[:height] = 0.25.in
      pdf.text_box("#{self.current_page}", options)
    end

    def debug_stroke(_pdf)
      # pdf.stroke_bounds
      # pdf.stroke do
      #   pdf.line [0, 0], [pdf.bounds.width, pdf.bounds.height]
      #   pdf.line [pdf.bounds.width, 0], [0, pdf.bounds.height]
      #   pdf.line [pdf.bounds.width / 2,
      #             pdf.bounds.height], [pdf.bounds.width / 2, 0]
      # end
    end
  end
end
