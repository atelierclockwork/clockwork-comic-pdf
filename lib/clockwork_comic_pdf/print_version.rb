require 'prawn'

module ClockworkComicPDF
  # Superclass of Prawn PDF Document that stores all of the variables
  # to print a version of the book
  class PrintVersion
    attr_accessor :version, :book, :pdf

    def initialize(book: nil, version: nil)
      @version = version
      @book = book
      @pdf = Prawn::Document.new(info: book.info, font_size: book.font_size,
                                 skip_page_creation: true)
      print_sections
      print_cover if version.print_cover && book.cover
      pdf.render_file "#{book.base_file_name} - #{version.name}.pdf"
    end

    def print_sections
    end

    def print_cover
      # pdf.go_to_page 0 if pdf.page_number > 0
      # cover = book.cover
      # pdf.start_new_page(size: cover.size, margin: 0)
      # puts
      # pdf.image("#{cover.path}/#{version.name}/#{cover.file}",
      #           at: pdf.bounds.top_left, scale: 72.0 / version.dpi.to_f)
    end
  end
end
