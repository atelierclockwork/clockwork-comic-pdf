require 'prawn'
require 'prawn/table'
require 'yaml'

require_relative 'clockwork_comic_pdf/book'
require_relative 'clockwork_comic_pdf/errors'
require_relative 'clockwork_comic_pdf/page_header'
require_relative 'clockwork_comic_pdf/cover'
require_relative 'clockwork_comic_pdf/version'
require_relative 'clockwork_comic_pdf/sections'
require_relative 'clockwork_comic_pdf/option_validation'
require_relative 'clockwork_comic_pdf/pdf_maker'

# the base module for ClockworkComicPDF
module ClockworkComicPDF
  def book_from_yaml(book)
    init_book_with_yaml(book).print
  end
  module_function :book_from_yaml

  def init_book_with_yaml(book)
    Book.new(YAML.load_file(book))
  end
  module_function :init_book_with_yaml
end
