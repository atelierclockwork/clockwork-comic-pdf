module ClockworkComicPDF
  # stores the PDF printing methods for making the table of contents
  module PDFTocMaker
    def print_toc(_pdf)
      # pdf.go_to_page(content_start - 1)
      # toc_start = pdf.page_number
      # new_page(pdf)
      # pdf.text 'Table of Contents', size: 18, align: :left
      # pdf.move_down(25)
      # page_index.each { |toc_item| make_toc_item(pdf, toc_item) }
      # new_page(pdf) unless (toc_start - pdf.page_number).even?
      # self.content_start += (toc_start - pdf.page_number)
    end

    def make_toc_item(_pdf, _toc_item)
      # content = [["#{toc_item[:name]}", "#{toc_item[:page]}"]]
      # options = { width: pdf.bounds.width / 2, position: :center,
      #             cell_style: { borders: [], size: 8,
      #                           padding: 1 } }
      # table = Prawn::Table.new(content, pdf, options) do
      #   cells.style { |c| c.align = c.column.zero? ? :left : :right }
      # end
      # new_page(pdf) if table.height >= pdf.cursor
      # table.draw
    end
  end
end
