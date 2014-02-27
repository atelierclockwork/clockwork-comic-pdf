require 'prawn'
require 'yaml'

require_relative 'clockwork_comic_pdf/book'
require_relative 'clockwork_comic_pdf/errors'
require_relative 'clockwork_comic_pdf/page_header'
require_relative 'clockwork_comic_pdf/cover'
require_relative 'clockwork_comic_pdf/version'
require_relative 'clockwork_comic_pdf/section'
require_relative 'clockwork_comic_pdf/option_validation'
require_relative 'clockwork_comic_pdf/pdf_maker'

# the base module for ClockworkComicPDF
module ClockworkComicPDF
  # VERSION "0.1.0"
  def book_from_yaml(book)
    parsed_book = Book.new(YAML.load_file(book))
    PDFMaker.new(parsed_book).print
  end
  module_function :book_from_yaml
end
