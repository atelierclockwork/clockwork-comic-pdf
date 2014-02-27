require_relative 'errors'
require_relative 'option_validation'

module ClockworkComicPDF
  # storage class for the page header
  # includes alignment, left and right side text, and size
  class PageHeader
    include OptionValidation
    def align
      @align = :center unless @align
      @align
    end
    attr_writer :align

    def text=(text)
      self.left_text = text
      self.right_text = text
    end

    def text
      { left: left_text, right: right_text }
    end

    def left_text
      @left_text ||= ''
    end

    def left_text=(left_text)
      @left_text = left_text.to_s
    end

    def right_text
      @right_text ||= ''
    end

    def right_text=(right_text)
      @right_text = right_text.to_s
    end

    def size
      @size = 8 unless @size
      @size
    end

    def size=(size)
      @size = size.to_points
    end

    def initialize(options = {})
      valid_options = [:size, :text, :left_text, :right_text, :align]
      check_options(options.keys, valid_options)
      self.size = options[:size]
      self.text = options[:text]
      self.left_text = options[:left_text]
      self.right_text = options[:right_text]
      self.align = options[:align]
    end
  end
end
