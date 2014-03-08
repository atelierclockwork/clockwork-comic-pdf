require_relative 'errors'
require_relative 'option_validation'

module ClockworkComicPDF
  # storage class for the page header
  # includes alignment, left and right side text, and size
  class PageHeader
    include OptionValidation

    attr_accessor :align, :left_text, :right_text, :size, :height, :v_align

    def initialize(options = {})
      load_options options
    end
  end
end
