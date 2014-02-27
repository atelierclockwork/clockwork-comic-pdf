module ClockworkComicPDF
  # initalization blocks for the book class
  module BookInit
    def valid_options
      [:font, :info, :base_file_name, :page_size, :margin,
       :offset_from_spine, :print_toc, :print_pagenum, :page_header,
       :versions, :sections, :font_size, :cover]
    end

    def initialize(options = {})
      check_options(options.keys, valid_options)
      initialize_options(options)
      initialize_content(options)
    end

    private

    def initialize_options(options = {})
      self.font = options[:font]
      self.base_file_name = options[:base_file_name]
      self.info = options[:info]
      self.page_size = options[:page_size]
      self.margin = options[:margin]
      self.offset_from_spine = options[:offset_from_spine]
      self.print_toc = options[:print_toc]
      self.print_pagenum = options[:print_pagenum]
    end

    def initialize_content(options = {})
      self.page_header = PageHeader.new(options[:page_header])
      self.cover = Cover.new(options[:cover])
      self.versions = Versions.new(options[:versions])
      self.sections = Sections.new(options[:sections])
      self.font_size = options[:font_size]
    end
  end
end
