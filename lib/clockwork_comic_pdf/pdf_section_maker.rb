module ClockworkComicPDF
  # this parses the sections of a book into a pdf file
  module PDFSectionMaker
    def print_sections(pdf, version)
      print_section(pdf, version, book.sections.front_matter)
      self.printing_body = true
      self.current_page = 0
      self.content_start = pdf.page_number + 1
      print_section(pdf, version, book.sections.body)
      self.printing_body = false
      print_section(pdf, version, book.sections.end_matter)
      new_page(pdf) if pdf.page_number.odd?
      print_toc(pdf) if book.print_toc
    end

    def print_section(pdf, version, section)
      section.each do |item|
        case item.type
        when :text_box
          print_text_box(pdf, version, item)
        when :formatted_text_box
          print_formatted_text_box(pdf, version, item)
        when :comic_pages
          print_comic_pages(pdf, version, item)
        end
      end
    end

    def print_comic_pages(pdf, version, comic_pages)
      puts comic_pages.name
      if comic_pages.print_section_intro
        print_section_break(pdf, comic_pages.name)
      end
      section_dir = "./#{version.name}/#{comic_pages.directory}/"
      Dir["#{section_dir}*.*"].each do |image|
        print_comic_image(pdf, version, image)
      end
    end

    def print_section_break(pdf, text)
      new_page(pdf)
      pdf.move_cursor_to pdf.bounds.top
      options = { valign: :center, align: :center, width: pdf.bounds.width,
                  height: pdf.bounds.height, size: 18,
                  at: pdf.bounds.top_left }
      page_index << { page: current_page, name: text } if printing_body
      pdf.text_box(text, options)
    end

    def print_comic_image(pdf, version, image)
      new_page(pdf)
      name = make_name(image)
      page_index << { page: current_page, name: "#{name}" } if printing_body
      content = [[name], [{ image: image, scale: 72.0 / version.dpi }]]
      table = Prawn::Table.new(content, pdf, cell_style: { borders: [] },
                                             position: :center)
      pdf.move_down((pdf.bounds.height - table.height) / 2.0)
      table.draw
    end

    def make_name(file_path)
      File.basename(file_path, '.*').split(' ').slice(1..-1).join(' ')
    end

    def print_text_box(pdf, version, content)
      text = File.new(content.file).read
      make_text_box(pdf, [{ text: text }], content)
    end

    def print_formatted_text_box(pdf, version, content)
      text = YAML.load_file(content.file)
      make_text_box(pdf, text, content)
    end

    def make_text_box(pdf, text, content)
      new_page(pdf)
      page_index << { page: current_page, name: content.name } if printing_body
      options = parse_options(pdf, content.options)
      pdf.formatted_text_box(text, options)
    end
  end
end
